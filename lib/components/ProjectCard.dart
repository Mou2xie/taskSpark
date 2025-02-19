import 'package:flutter/material.dart';
import '../models/ProjectModel.dart';

// The top component in the project detail page
class ProjectCard extends StatelessWidget {
  final Project project;

  ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 138, 138, 138)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(project.projectName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 20),
              SizedBox(width: 5),
              Text(
                "${project.durationRange.start.month}.${project.durationRange.start.day} - ${project.durationRange.end.month}.${project.durationRange.end.day}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(project.projectDescription ?? '',
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: project.members.map((member) => member.avatar).toList(),
          )
        ],
      ),
    );
  }
}


