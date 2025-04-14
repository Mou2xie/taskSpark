import 'package:flutter/material.dart';
import '../models/ProjectModel.dart';
import '../models/Member.dart';
import '../services/database_service.dart';

class ProjectsListProvider extends ChangeNotifier {
  final List<Project> _projectsList = [];
  final DatabaseService _databaseService = DatabaseService();

  List<Project> get projectsList => _projectsList;

  ProjectsListProvider() {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projects = await _databaseService.getProjects();
    _projectsList.clear();
    _projectsList.addAll(projects);
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    await _databaseService.insertProject(project);
    await _loadProjects();
  }

  Future<void> removeProject(Project project) async {
    await _databaseService.deleteProject(project.id);
    await _loadProjects();
  }
}
