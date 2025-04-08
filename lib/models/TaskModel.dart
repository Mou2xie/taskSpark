import 'TaskStatus.dart';
import 'Member.dart';
import 'TaskPriority.dart';
import 'Comment.dart';
import 'package:flutter/material.dart';

enum TaskStatus {
  notStarted,
  inProgress,
  finished
}

extension TaskStatusExtension on TaskStatus {
  String get string {
    switch (this) {
      case TaskStatus.notStarted:
        return 'Not Started';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.finished:
        return 'Finished';
    }
  }
}

enum TaskPriority {
  low,
  medium,
  high
}

extension TaskPriorityExtension on TaskPriority {
  String get string {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}

class Task {
  static int _id = 0;

  late int id;
  late TaskStatus status;
  final String taskName;
  final String? description;
  final DateTimeRange duration;
  final Member assignTo;
  final TaskPriority priority;
  bool _isPinned = false;
  final DateTime createTime;
  final List<Comment> comments = [];

  bool get isPinned => _isPinned;

  void setPinned(bool value) {
    _isPinned = value;
  }

  void addComment(Comment comment) {
    comments.add(comment);
  }

  Task({
    required this.taskName,
    this.description,
    required this.duration,
    required this.assignTo,
    required this.priority,
    required this.status,
  }) : createTime = DateTime.now() {
    id = ++Task._id;
  }

  void updateStatus(TaskStatus newStatus) {
    status = newStatus;
  }
}
