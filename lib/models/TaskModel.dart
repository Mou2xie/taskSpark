import 'TaskStatus.dart';
import 'Member.dart';
import 'TaskPriority.dart';
import 'package:flutter/material.dart';

class Task {
  static int _id = 0;

  late int id;
  late TaskStatus status;
  String taskName;
  DateTimeRange duration;
  Member assignTo;
  Taskpriority priority;

  Task(
      {required this.taskName,
      required this.duration,
      required this.assignTo,
      required this.priority}) {
    id = ++Task._id;
    status = TaskStatus.notStarted;
  }

  void updateStatus(TaskStatus newStatus) {
    status = newStatus;
  }
}
