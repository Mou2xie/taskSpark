import 'package:flutter/material.dart';
import 'package:project_manager/models/ProjectModel.dart';
import 'package:project_manager/route/projectDetail.dart';

class ProjectItem extends StatelessWidget {
  final Project project;

  ProjectItem({required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProjectDetail()));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffCFCFCF)),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: EdgeInsets.all(12),
          height: 140,
          width: double.infinity,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.projectName,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(
                      "${project.startDate.month}.${project.startDate.day} - ${project.endDate.month}.${project.endDate.day}",
                      style: TextStyle(fontSize: 16, color: Color(0xff5B6061))),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: project.members
                              .map((item) => item.avatar)
                              .toList(),
                        )),
                  )
                ],
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "10",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "/30",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
