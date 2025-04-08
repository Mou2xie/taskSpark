import 'package:flutter/material.dart';
import 'package:project_manager/providers/taskProvider.dart';
import 'package:provider/provider.dart';
import '../models/TaskModel.dart';

// shown in the project detail page
class TaskItem extends StatelessWidget {
  late Task task;

  TaskItem({required this.task});

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.finished:
        return Colors.green;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffCFCFCF)),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(12),
          height: 130,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // task name with pin icon
                    Row(
                      children: [
                        Text(task.taskName,
                            style:
                                TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        if (task.isPinned) ...[
                          SizedBox(width: 8),
                          Icon(Icons.push_pin, 
                              color: Colors.blue, 
                              size: 20,
                              textDirection: TextDirection.ltr),
                        ],
                      ],
                    ),
                    SizedBox(height: 8),
                    // task duration
                    Text(
                        "${task.duration.start.month}.${task.duration.start.day} - ${task.duration.end.month}.${task.duration.end.day}",
                        style: TextStyle(fontSize: 16, color: Color(0xff5B6061))),
                    Spacer(),
                    // assigned member
                    Row(
                      children: [
                        task.assignTo.defaultAvatar,
                        SizedBox(width: 8),
                        Text(task.assignTo.name,
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // task priority
                  Text(task.priority.string,
                      style: TextStyle(
                          fontSize: 22,
                          color: task.priority.color,
                          fontWeight: FontWeight.bold)),
                  PopupMenuButton(
                      icon: Icon(
                        Icons.more_horiz,
                        size: 35,
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              child: ListTile(
                            title: Text(task.isPinned ? 'Unpin' : 'Pin'),
                            onTap: () {
                              if (task.isPinned) {
                                taskProvider.unpinTask(task);
                              } else {
                                taskProvider.pinTask(task);
                              }
                              Navigator.pop(context);
                            },
                          )),
                          PopupMenuItem(
                              child: ListTile(
                            title: Text('Not Start'),
                            onTap: () {
                              taskProvider.updateTaskStatus(
                                  task, TaskStatus.notStarted);
                              Navigator.pop(context);
                            },
                          )),
                          PopupMenuItem(
                              child: ListTile(
                            title: Text('In Progress'),
                            onTap: () {
                              taskProvider.updateTaskStatus(
                                  task, TaskStatus.inProgress);
                              Navigator.pop(context);
                            },
                          )),
                          PopupMenuItem(
                              child: ListTile(
                            title: Text('Finished'),
                            onTap: () {
                              taskProvider.updateTaskStatus(
                                  task, TaskStatus.finished);
                              Navigator.pop(context);
                            },
                          )),
                        ];
                      })
                ],
              ),
            ],
          ));
    });
  }
}
