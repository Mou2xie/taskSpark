import 'package:flutter/material.dart';
import 'package:project_manager/providers/taskProvider.dart';
import './createTask.dart';
import '../components/ProjectCard.dart';
import '../components/TaskList.dart';
import '../components/TaskItem.dart';
import '../models/ProjectModel.dart';
import '../models/TaskModel.dart';
import '../models/TaskSortMethod.dart';
import '../models/Member.dart';
import '../models/TaskPriority.dart';
import 'package:provider/provider.dart';
import '../providers/projectsListProvider.dart';
import './taskDetail.dart';

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

  Widget _buildTaskStatistics(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = project.tasks;
        final notStartedCount = tasks.where((t) => t.status == TaskStatus.notStarted).length;
        final inProgressCount = tasks.where((t) => t.status == TaskStatus.inProgress).length;
        final finishedCount = tasks.where((t) => t.status == TaskStatus.finished).length;

        return Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Not Started', notStartedCount, Colors.grey),
                  _buildStatItem('In Progress', inProgressCount, Colors.orange),
                  _buildStatItem('Finished', finishedCount, Colors.green),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectCard(project: project),
              SizedBox(height: 20),
              _buildTaskStatistics(context),
              // Filter and sort options
              Card(
                margin: EdgeInsets.zero,
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.filter_list),
                      SizedBox(width: 10),
                      Text(
                        "Filter & Sort",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (taskProvider.filterStatus != null ||
                          taskProvider.filterPriority != null ||
                          taskProvider.filterMember != null) ...[
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Filtered",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  taskProvider.clearFilters();
                                },
                                icon: Icon(Icons.clear_all),
                                label: Text("Clear Filters"),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 20,
                            runSpacing: 15,
                            children: [
                              // Status filter
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Status:"),
                                  SizedBox(width: 8),
                                  DropdownButton<TaskStatus?>(
                                    value: taskProvider.filterStatus,
                                    hint: Text("All"),
                                    onChanged: (value) {
                                      taskProvider.setFilterStatus(value);
                                    },
                                    items: [
                                      DropdownMenuItem<TaskStatus?>(
                                        value: null,
                                        child: Text("All"),
                                      ),
                                      ...TaskStatus.values.map((status) {
                                        return DropdownMenuItem<TaskStatus>(
                                          value: status,
                                          child: Text(status.string),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ],
                              ),
                              // Priority filter
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Priority:"),
                                  SizedBox(width: 8),
                                  DropdownButton<TaskPriority?>(
                                    value: taskProvider.filterPriority,
                                    hint: Text("All"),
                                    onChanged: (value) {
                                      taskProvider.setFilterPriority(value);
                                    },
                                    items: [
                                      DropdownMenuItem<TaskPriority?>(
                                        value: null,
                                        child: Text("All"),
                                      ),
                                      ...TaskPriority.values.map((priority) {
                                        return DropdownMenuItem<TaskPriority>(
                                          value: priority,
                                          child: Text(priority.string),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ],
                              ),
                              // Member filter
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Member:"),
                                  SizedBox(width: 8),
                                  DropdownButton<Member?>(
                                    value: taskProvider.filterMember,
                                    hint: Text("All"),
                                    onChanged: (value) {
                                      taskProvider.setFilterMember(value);
                                    },
                                    items: [
                                      DropdownMenuItem<Member?>(
                                        value: null,
                                        child: Text("All"),
                                      ),
                                      ...project.members.map((member) {
                                        return DropdownMenuItem<Member>(
                                          value: member,
                                          child: Text(member.name),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ],
                              ),
                              // Sort method
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Sort:"),
                                  SizedBox(width: 8),
                                  DropdownButton<TaskSortMethod>(
                                    value: taskProvider.currentSortMethod,
                                    onChanged: (TaskSortMethod? method) {
                                      if (method != null) {
                                        taskProvider.setSortMethod(method);
                                      }
                                    },
                                    items: TaskSortMethod.values.map((method) {
                                      return DropdownMenuItem<TaskSortMethod>(
                                        value: method,
                                        child: Text(method.string),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 任务列表
              ...taskProvider.getFilteredAndSortedTasks(project.tasks).map((task) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetail(
                              task: task,
                              currentUser: project.members.first,
                              project: project,
                            ),
                          ),
                        );
                      },
                      child: TaskItem(task: task),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
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