import 'package:flutter/material.dart';
import '../models/TaskModel.dart';
import '../models/ProjectModel.dart';
import '../models/TaskSortMethod.dart';
import '../models/Member.dart';
import '../models/TaskPriority.dart';

class TaskProvider extends ChangeNotifier {
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

  void updateTaskStatus(Task task, TaskStatus status) {
    task.status = status;
    notifyListeners();
  }

  void addtaskToProject(Task task, Project project) {
    project.addTask(task);
    notifyListeners();
  }

  void pinTask(Task task) {
    task.setPinned(true);
    notifyListeners();
  }

  void unpinTask(Task task) {
    task.setPinned(false);
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

  // Get status weight for sorting
  int _getStatusWeight(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return 0;
      case TaskStatus.inProgress:
        return 1;
      case TaskStatus.finished:
        return 2;
    }
  }

  // Get priority weight for sorting (T0 highest, T2 lowest)
  int _getPriorityWeight(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 0;
      case TaskPriority.medium:
        return 1;
      case TaskPriority.low:
        return 2;
    }
    return 0;
  }

  List<Task> getFilteredAndSortedTasks(List<Task> tasks) {
    // Apply filters
    var filteredTasks = tasks.where((task) {
      bool matchesStatus = _filterStatus == null || task.status == _filterStatus;
      bool matchesPriority = _filterPriority == null || task.priority == _filterPriority;
      bool matchesMember = _filterMember == null || task.assignTo == _filterMember;
      return matchesStatus && matchesPriority && matchesMember;
    }).toList();
    
    // Sort tasks
    filteredTasks.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      
      // First sort by status
      int statusCompare = _getStatusWeight(a.status).compareTo(_getStatusWeight(b.status));
      if (statusCompare != 0) return statusCompare;

      // Then sort by selected method
      switch (_currentSortMethod) {
        case TaskSortMethod.by_time:
          return b.createTime.compareTo(a.createTime);
        case TaskSortMethod.by_priority:
          return _getPriorityWeight(a.priority).compareTo(_getPriorityWeight(b.priority));
      }
    });
    
    return filteredTasks;
  }
}
