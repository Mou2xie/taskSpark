import 'package:flutter/material.dart';
import '../models/ProjectModel.dart';
import '../models/Member.dart';

class ProjectsListProvider extends ChangeNotifier {
  // init data for test, need to clean up
  final List<Project> _projectsList = List<Project>.generate(
      1,
      (index) => Project(
            projectName: 'Flutter Group Assignment #1',
            durationRange: DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(Duration(days: 5))),
            projectDescription:
                "This assignemnt requires us to build a simple app using flutter",
            members: [Member.isha, Member.sam, Member.shamshad, Member.xie],
          ));

  List<Project> get projectsList => _projectsList;

  void addProject(Project project) {
    _projectsList.add(project);
    notifyListeners();
  }

  void removeProject(Project project) {
    _projectsList.remove(project);
    notifyListeners();
  }
}
