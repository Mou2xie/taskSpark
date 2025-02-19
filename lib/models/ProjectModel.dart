import 'TaskModel.dart';
import 'Member.dart';
import 'TaskPriority.dart';
import 'TaskStatus.dart';
import 'package:flutter/material.dart';

class Project {
  static int _id = 0;

  late int id;
  String projectName;
  DateTimeRange durationRange;
  String? projectDescription;
  List<Member> members = [];
  List<Task> tasks = [];

  int get totalTasks => tasks.length;
  int get finishedTasks =>
      tasks.where((task) => task.status == TaskStatus.finished).length;

  Project({
    required this.projectName,
    required this.durationRange,
    required this.members,
    this.projectDescription,
  }) {
    id = ++Project._id;
  }

  void addTask(Task task) {
    tasks.add(task);
  }

  List<Task> getTasksByStatus(TaskStatus status) {
    return tasks.where((task) => task.status == status).toList();
  }

}
