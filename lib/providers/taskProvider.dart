import 'package:flutter/material.dart';
import '../models/TaskModel.dart';
import '../models/ProjectModel.dart';
import '../models/TaskSortMethod.dart';
import '../models/Member.dart';
import '../models/TaskPriority.dart';
import '../services/database_service.dart';
import '../models/Comment.dart';

class TaskProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  TaskSortMethod _currentSortMethod = TaskSortMethod.by_time;
  TaskStatus? _filterStatus;
  TaskPriority? _filterPriority;
  Member? _filterMember;
  Project? _currentProject;

  TaskSortMethod get currentSortMethod => _currentSortMethod;
  TaskStatus? get filterStatus => _filterStatus;
  TaskPriority? get filterPriority => _filterPriority;
  Member? get filterMember => _filterMember;
  List<Task> get tasks => _currentProject?.tasks ?? [];

  void setCurrentProject(Project project) {
    _currentProject = project;
    notifyListeners();
  }

  Future<void> updateTaskStatus(Task task, TaskStatus status) async {
    task.status = status;
    await _databaseService.updateTaskStatus(task.id, status);
    notifyListeners();
  }

  Future<void> addtaskToProject(Task task, Project project) async {
    await _databaseService.insertTask(task, project.id);
    project.addTask(task);
    notifyListeners();
  }

  Future<void> pinTask(Task task) async {
    task.setPinned(true);
    await _databaseService.updateTaskPin(task.id, true);
    notifyListeners();
  }

  Future<void> unpinTask(Task task) async {
    task.setPinned(false);
    await _databaseService.updateTaskPin(task.id, false);
    notifyListeners();
  }

  Future<void> addComment(Task task, Comment comment) async {
    await _databaseService.insertComment(comment, task.id);
    task.addComment(comment);
    notifyListeners();
  }

  void setSortMethod(TaskSortMethod method) {
    _currentSortMethod = method;
    notifyListeners();
  }

  void setFilterStatus(TaskStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setFilterPriority(TaskPriority? priority) {
    _filterPriority = priority;
    notifyListeners();
  }

  void setFilterMember(Member? member) {
    _filterMember = member;
    notifyListeners();
  }

  void clearFilters() {
    _filterStatus = null;
    _filterPriority = null;
    _filterMember = null;
    notifyListeners();
  }

  List<Task> getFilteredAndSortedTasks(List<Task> tasks) {
    // 应用过滤器
    if (_filterStatus != null) {
      tasks = tasks.where((task) => task.status == _filterStatus).toList();
    }
    if (_filterPriority != null) {
      tasks = tasks.where((task) => task.priority == _filterPriority).toList();
    }
    if (_filterMember != null) {
      tasks = tasks.where((task) => task.assignTo.name == _filterMember!.name).toList();
    }

    // 应用排序
    switch (_currentSortMethod) {
      case TaskSortMethod.by_time:
        tasks.sort((a, b) => b.createTime.compareTo(a.createTime));
        break;
      case TaskSortMethod.by_priority:
        tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
    }

    return tasks;
  }
}
