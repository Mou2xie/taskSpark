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
            members: [
              Member(
                name: 'Isha',
                avatar: CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/images/isha.png'),
                ),
              ),
              Member(
                name: 'Sam',
                avatar: CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/images/sam.png'),
                ),
              ),
              Member(
                name: 'Shamshad',
                avatar: CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/images/sham.png'),
                ),
              ),
              Member(
                name: 'Xie',
                avatar: CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/images/xie.png'),
                ),
              ),
            ],
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
