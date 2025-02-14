import 'package:flutter/material.dart';
import '../models/TaskModel.dart';

class TaskItem extends StatelessWidget {
  late Task task;

  TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffCFCFCF)),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(12),
        height: 140,
        width: double.infinity,
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // project name
              Text(task.taskName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

              // project duration
              Text(
                  "${task.duration.start.month}.${task.duration.start.day} - ${task.duration.end.month}.${task.duration.end.day}",
                  style: TextStyle(fontSize: 16, color: Color(0xff5B6061))),

              Expanded(
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      // project members
                      child: task.assignTo.avatar))
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // project priority
              Text(task.priority.string,
                  style: TextStyle(
                      fontSize: 22,
                      color: task.priority.color,
                      fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    size: 35,
                  ))
            ],
          ),
        ]));
  }
}
