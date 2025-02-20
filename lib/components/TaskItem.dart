import 'package:flutter/material.dart';
import 'package:project_manager/providers/taskProvider.dart';
import 'package:provider/provider.dart';
import '../models/TaskModel.dart';
import '../models/TaskStatus.dart';

// shown in the project detail page
class TaskItem extends StatelessWidget {
  late Task task;

  TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Container(
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffCFCFCF)),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(12),
          height: 130,
          width: double.infinity,
          child: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // task name
                Text(task.taskName,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                // task duration
                Text(
                    "${task.duration.start.month}.${task.duration.start.day} - ${task.duration.end.month}.${task.duration.end.day}",
                    style: TextStyle(fontSize: 16, color: Color(0xff5B6061))),

                Expanded(
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        // task members
                        child: task.assignTo.avatar))
              ],
            ),
            Spacer(),
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
                          title: Text('Not Start'),
                          onTap: () {
                            // update task status to not started
                            taskProvider.updateTaskStatus(
                                task, TaskStatus.notStarted);
                            Navigator.pop(context);
                          },
                        )),
                        PopupMenuItem(
                            child: ListTile(
                          title: Text('In Progress'),
                          onTap: () {
                            // update task status to in progress
                            taskProvider.updateTaskStatus(
                                task, TaskStatus.inProgress);
                            Navigator.pop(context);
                          },
                        )),
                        PopupMenuItem(
                            child: ListTile(
                          title: Text('Finished'),
                          onTap: () {
                            // update task status to finished
                            taskProvider.updateTaskStatus(
                                task, TaskStatus.finished);
                            Navigator.pop(context);
                          },
                        )),
                      ];
                    })
              ],
            ),
          ]));
    });
  }
}
