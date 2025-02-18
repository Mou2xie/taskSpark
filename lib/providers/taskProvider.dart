import 'package:flutter/material.dart';
import '../models/TaskStatus.dart';
import '../models/TaskModel.dart';
import '../models/ProjectModel.dart';

class TaskProvider extends ChangeNotifier {
  void updateTaskStatus(Task task, TaskStatus status) {
    task.status = status;
    notifyListeners();
  }

  void addtaskToProject(Task task, Project project) {
    project.addTask(task);
    notifyListeners();
  }
}
