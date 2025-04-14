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
    // create projects table
    await db.execute('''
      CREATE TABLE projects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectName TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        projectDescription TEXT
      )
    ''');

    // create members table
    await db.execute('''
      CREATE TABLE members(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        projectId INTEGER NOT NULL,
        name TEXT NOT NULL,
        avatarPath TEXT,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    // create tasks table
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

    // create comments table
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

    // insert members
    for (var member in project.members) {
      await db.insert('members', {
        'projectId': projectId,
        'name': member.name,
        'avatarPath': null, // Assuming avatarPath is not used for now
      });
    }

    return projectId;
  }

  Future<List<Project>> getProjects() async {
    final db = await database;
    final List<Map<String, dynamic>> projectMaps = await db.query('projects');
    
    List<Project> projects = [];
    for (var projectMap in projectMaps) {
      // getting members for each project
      final List<Map<String, dynamic>> memberMaps = await db.query(
        'members',
        where: 'projectId = ?',
        whereArgs: [projectMap['id']],
      );

      List<Member> members = memberMaps.map((memberMap) {
        return Member(
          id: memberMap['id'],
          name: memberMap['name'],
          avatar: memberMap['avatarPath'] != null
              ? CircleAvatar(backgroundImage: AssetImage(memberMap['avatarPath']))
              : null,
        );
      }).toList();

      // create project object
      Project project = Project(
        projectName: projectMap['projectName'],
        durationRange: DateTimeRange(
          start: DateTime.parse(projectMap['startDate']),
          end: DateTime.parse(projectMap['endDate']),
        ),
        projectDescription: projectMap['projectDescription'],
        members: members,
        dbId: projectMap['id'],  // setting the database ID
      );

      // getting tasks for each project
      final List<Map<String, dynamic>> taskMaps = await db.query(
        'tasks',
        where: 'projectId = ?',
        whereArgs: [projectMap['id']],  // search tasks by project ID
      );

      for (var taskMap in taskMaps) {
        // getting comments for each task
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

        // create task object
        Task task = Task(
          taskName: taskMap['taskName'],
          description: taskMap['description'],
          duration: DateTimeRange(
            start: DateTime.parse(taskMap['startDate']),
            end: DateTime.parse(taskMap['endDate']),
          ),
          assignTo: members.firstWhere(
            (m) => m.id == taskMap['assignToId'],  // use member ID to find the member
            orElse: () => Member(name: '未分配'),
          ),
          priority: TaskPriority.values[taskMap['priority']],
          status: TaskStatus.values[taskMap['status']],
        );
        task.id = taskMap['id']; 

        // add comments to task
        for (var commentMap in commentMaps) {
          Comment comment = Comment(
            content: commentMap['content'],
            createTime: DateTime.parse(commentMap['createTime']), 
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
    // 先获取成员的 ID
    final List<Map<String, dynamic>> memberResult = await db.query(
      'members',
      where: 'name = ? AND projectId = ?',
      whereArgs: [task.assignTo.name, projectId],
    );
    
    if (memberResult.isEmpty) {
      throw Exception('找不到指定的成员');
    }
    
    final int memberId = memberResult.first['id'] as int;
    
    return await db.insert('tasks', {
      'projectId': projectId,
      'taskName': task.taskName,
      'description': task.description,
      'startDate': task.duration.start.toIso8601String(),
      'endDate': task.duration.end.toIso8601String(),
      'assignToId': memberId,  // 使用成员 ID 而不是名字
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