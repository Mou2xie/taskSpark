import 'package:flutter/material.dart';
import '../models/ProjectModel.dart';
import '../models/Member.dart';
import '../models/TaskStatus.dart';

class ProjectsListProvider extends ChangeNotifier {

  // init data for test, need to clean up
  final List<Project> _projectsList = List<Project>.generate(
      1,
      (index) => Project(
          projectName: 'Flutter Group Assignment #1',
          durationRange: DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(Duration(days: 5))),
          projectDescription: "This assignemnt requires us to build a simple app using flutter",
          members: [Member.xie, Member.sam]));

  List<Project> get projectsList => _projectsList;

  void addProject(Project project) {
    _projectsList.add(project);
    notifyListeners();
  }

  // remove project not used for now
  void removeProject(Project project) {
    _projectsList.remove(project);
    notifyListeners();
  }
}
