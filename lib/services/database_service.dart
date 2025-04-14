import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../models/ProjectModel.dart';
import '../models/TaskModel.dart';
import '../models/Member.dart';
import '../models/Comment.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_spark.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 创建项目表
    await db.execute('''
      CREATE TABLE projects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectName TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        projectDescription TEXT
      )
    ''');

    // 创建成员表
    await db.execute('''
      CREATE TABLE members(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectId INTEGER NOT NULL,
        name TEXT NOT NULL,
        avatarPath TEXT,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    // 创建任务表
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectId INTEGER NOT NULL,
        taskName TEXT NOT NULL,
        description TEXT,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        assignToId INTEGER NOT NULL,
        priority INTEGER NOT NULL,
        status INTEGER NOT NULL,
        isPinned INTEGER NOT NULL,
        createTime TEXT NOT NULL,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE,
        FOREIGN KEY (assignToId) REFERENCES members (id) ON DELETE CASCADE
      )
    ''');

    // 创建评论表
    await db.execute('''
      CREATE TABLE comments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER NOT NULL,
        content TEXT NOT NULL,
        createTime TEXT NOT NULL,
        FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');
  }

  // Project CRUD operations
  Future<int> insertProject(Project project) async {
    final db = await database;
    final projectId = await db.insert('projects', {
      'projectName': project.projectName,
      'startDate': project.durationRange.start.toIso8601String(),
      'endDate': project.durationRange.end.toIso8601String(),
      'projectDescription': project.projectDescription,
    });

    // 插入项目成员
    for (var member in project.members) {
      await db.insert('members', {
        'projectId': projectId,
        'name': member.name,
        'avatarPath': null, // 暂时不处理头像
      });
    }

    return projectId;
  }

  Future<List<Project>> getProjects() async {
    final db = await database;
    final List<Map<String, dynamic>> projectMaps = await db.query('projects');
    
    List<Project> projects = [];
    for (var projectMap in projectMaps) {
      // 获取项目成员
      final List<Map<String, dynamic>> memberMaps = await db.query(
        'members',
        where: 'projectId = ?',
        whereArgs: [projectMap['id']],
      );

      List<Member> members = memberMaps.map((memberMap) {
        return Member(
          name: memberMap['name'],
          avatar: memberMap['avatarPath'] != null
              ? CircleAvatar(backgroundImage: AssetImage(memberMap['avatarPath']))
              : null,
        );
      }).toList();

      // 创建项目对象
      Project project = Project(
        projectName: projectMap['projectName'],
        durationRange: DateTimeRange(
          start: DateTime.parse(projectMap['startDate']),
          end: DateTime.parse(projectMap['endDate']),
        ),
        projectDescription: projectMap['projectDescription'],
        members: members,
        dbId: projectMap['id'],  // 设置数据库ID
      );

      // 获取项目任务
      final List<Map<String, dynamic>> taskMaps = await db.query(
        'tasks',
        where: 'projectId = ?',
        whereArgs: [projectMap['id']],  // 使用数据库ID查询任务
      );

      for (var taskMap in taskMaps) {
        // 获取任务评论
        final List<Map<String, dynamic>> commentMaps = await db.query(
          'comments',
          where: 'taskId = ?',
          whereArgs: [taskMap['id']],
        );

        List<Comment> comments = commentMaps.map((commentMap) {
          return Comment(
            content: commentMap['content'],
          );
        }).toList();

        // 创建任务对象
        Task task = Task(
          taskName: taskMap['taskName'],
          description: taskMap['description'],
          duration: DateTimeRange(
            start: DateTime.parse(taskMap['startDate']),
            end: DateTime.parse(taskMap['endDate']),
          ),
          assignTo: members.firstWhere(
            (m) => m.name == taskMap['assignToId'].toString(),
          ),
          priority: TaskPriority.values[taskMap['priority']],
          status: TaskStatus.values[taskMap['status']],
        );
        task.id = taskMap['id'];  // 设置任务的数据库ID

        // 添加评论到任务
        for (var commentMap in commentMaps) {
          Comment comment = Comment(
            content: commentMap['content'],
            createTime: DateTime.parse(commentMap['createTime']),  // 使用数据库中保存的时间
          );
          task.addComment(comment);
        }

        project.addTask(task);
      }

      projects.add(project);
    }

    return projects;
  }

  Future<void> deleteProject(int projectId) async {
    final db = await database;
    await db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [projectId],
    );
  }

  // Task CRUD operations
  Future<int> insertTask(Task task, int projectId) async {
    final db = await database;
    return await db.insert('tasks', {
      'projectId': projectId,
      'taskName': task.taskName,
      'description': task.description,
      'startDate': task.duration.start.toIso8601String(),
      'endDate': task.duration.end.toIso8601String(),
      'assignToId': task.assignTo.name,
      'priority': task.priority.index,
      'status': task.status.index,
      'isPinned': task.isPinned ? 1 : 0,
      'createTime': task.createTime.toIso8601String(),
    });
  }

  Future<void> updateTaskStatus(int taskId, TaskStatus status) async {
    final db = await database;
    await db.update(
      'tasks',
      {'status': status.index},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> updateTaskPin(int taskId, bool isPinned) async {
    final db = await database;
    await db.update(
      'tasks',
      {'isPinned': isPinned ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // Comment operations
  Future<int> insertComment(Comment comment, int taskId) async {
    final db = await database;
    return await db.insert('comments', {
      'taskId': taskId,
      'content': comment.content,
      'createTime': comment.createTime.toIso8601String(),
    });
  }
} 