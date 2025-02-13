import 'package:flutter/material.dart';
import 'package:project_manager/components/ProjectItem.dart';
import 'package:project_manager/models/ProjectModel.dart';
import 'package:provider/provider.dart';
import 'createProject.dart';
import 'package:project_manager/providers/projectsListProvider.dart';

void main(List<String> args) {
  runApp(ProjectList());
}

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get project list data from ProjectsListProvider
    return Consumer<ProjectsListProvider>(
        builder: (context, projectsListProvider, child) {
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
                  // navigate to create project page with + btn
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateProject()));
                },
              ),
            ],
          ),
          // make list with projects form ProjectsListProvider
          body: ListView.builder(
              itemCount: projectsListProvider.projectsList.length,
              itemBuilder: (context, index) {
                // pass project data to ProjectItem
                return ProjectItem(
                    project: projectsListProvider.projectsList[index]);
              }));
    });
  }
}
