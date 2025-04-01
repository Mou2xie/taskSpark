import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/TaskModel.dart';
import '../models/TaskSortMethod.dart';
import '../components/TaskItem.dart';
import '../providers/taskProvider.dart';

// display a list of tasks with the specific status
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final TaskStatus taskStatus;

  TaskList({
    required this.tasks,
    required this.taskStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      final sortedTasks = taskProvider.getFilteredAndSortedTasks(tasks);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(taskStatus.string,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text("${sortedTasks.length}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: sortedTasks.map((task) => TaskItem(task: task)).toList(),
          ),
        ],
      );
    });
  }
}
