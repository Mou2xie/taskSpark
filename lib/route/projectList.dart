import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(ProjectList());
}

class ProjectList extends StatelessWidget {
  final List<String> projectList = ['Project 1', 'Project 2', 'Project 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Project List',
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
            itemCount: projectList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(projectList[index]),
                onTap: () {
                  // jump to projectDetail page, undone
                },
              );
            }));
  }
}
