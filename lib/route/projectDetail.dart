import 'package:flutter/material.dart';
import 'package:project_manager/providers/taskProvider.dart';
import './createTask.dart';
import '../components/ProjectCard.dart';
import '../components/TaskList.dart';
import '../models/ProjectModel.dart';
import '../models/TaskStatus.dart';
import 'package:provider/provider.dart';
import '../providers/projectsListProvider.dart';

class ProjectDetail extends StatelessWidget {
  final Project project;

  ProjectDetail({required this.project});

  Future showDeleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Comfirm Delete"),
          content: Text("Do you want to delete this project?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Provider.of<ProjectsListProvider>(context, listen: false)
                    .removeProject(project);
                Navigator.pop(context);
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project Detail',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.settings, size: 40),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    title: Text("Delete"),
                    leading: Icon(Icons.delete),
                  ),
                  onTap: () {
                    showDeleteDialog(context);
                  },
                )
              ];
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(builder: (context, taskProvider, child) {
        return SingleChildScrollView(
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
        );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateTask(project: project)));
          },
          child: Icon(Icons.add)),
    );
  }
}
