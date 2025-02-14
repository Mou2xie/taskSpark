import 'package:flutter/material.dart';
import '../models/TaskModel.dart';
import '../models/TaskStatus.dart';
import '../components/TaskItem.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final TaskStatus taskStatus;

  TaskList({required this.tasks, required this.taskStatus});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(taskStatus.string,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Text("${tasks.length}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ],
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskItem(task: tasks[index]);
          },
        ),
      ],
    );
  }
}
