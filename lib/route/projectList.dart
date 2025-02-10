import 'package:flutter/material.dart';
import 'package:project_manager/components/ProjectItem.dart';
import 'package:project_manager/models/ProjectModel.dart';

void main(List<String> args) {
  runApp(ProjectList());
}

class ProjectList extends StatelessWidget {

  final projects = List<Project>.generate(
      5,
      (index) => Project(
          projectName: 'Project lalalalal $index',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          tasks: []));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Projects',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, size: 40),
              onPressed: () {
                // jump to create peorject page, undone
              },
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return ProjectItem(project: projects[index]);
            }));
  }
}
