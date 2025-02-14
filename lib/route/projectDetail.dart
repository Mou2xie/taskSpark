import 'package:flutter/material.dart';
import './createTask.dart';
import '../components/ProjectCard.dart';
import '../components/TaskList.dart';
import '../models/ProjectModel.dart';
import '../models/TaskStatus.dart';

class ProjectDetail extends StatelessWidget {
  final Project project;

  ProjectDetail({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project Detail',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 40),
            onPressed: () {
              // should be a dropdown list
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            ProjectCard(project: project),
            SizedBox(height: 20),
            TaskList(
                tasks: project.getTasksByStatus(TaskStatus.notStarted),
                taskStatus: TaskStatus.notStarted),
            SizedBox(height: 20),
            TaskList(
                tasks: project.getTasksByStatus(TaskStatus.inProgress),
                taskStatus: TaskStatus.inProgress),
            SizedBox(height: 20),
            TaskList(
                tasks: project.getTasksByStatus(TaskStatus.finished),
                taskStatus: TaskStatus.finished),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateTask()));
          },
          child: Icon(Icons.add)),
    );
  }
}
