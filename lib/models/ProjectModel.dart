import 'TaskModel.dart';
import 'Member.dart';
import 'package:flutter/material.dart';

class Project {
  static int _id = 0;

  late int id;
  String projectName;
  DateTimeRange durationRange;
  String? projectDescription;
  List<Member> members = [];
  List<Task> tasks = [];

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
}
