import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/TaskModel.dart';
import '../models/Comment.dart';
import '../models/Member.dart';
import '../models/ProjectModel.dart';
import '../providers/taskProvider.dart';
import 'package:intl/intl.dart';

class TaskDetail extends StatefulWidget {
  final Task task;
  final Member currentUser;
  final Project project;

  TaskDetail({
    required this.task, 
    required this.currentUser,
    required this.project,
  });

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).setCurrentProject(widget.project);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color getStatusColor(TaskStatus status) {
      switch (status) {
        case TaskStatus.notStarted:
          return Colors.grey;
        case TaskStatus.inProgress:
          return Colors.orange;
        case TaskStatus.finished:
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: getStatusColor(status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.string,
        style: TextStyle(
          color: getStatusColor(status),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: priority.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        priority.string,
        style: TextStyle(
          color: priority.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Detail'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task info card
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.taskName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (widget.task.description != null && widget.task.description!.isNotEmpty) ...[
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.task.description!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '${DateFormat('MMM dd').format(widget.task.duration.start)} - ${DateFormat('MMM dd').format(widget.task.duration.end)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStatusChip(widget.task.status),
                          SizedBox(width: 8),
                          _buildPriorityChip(widget.task.priority),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text('Assigned to: ', style: TextStyle(fontSize: 16)),
                          widget.task.assignTo.defaultAvatar,
                          SizedBox(width: 8),
                          Text(widget.task.assignTo.name, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Comments section
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Comment input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (_commentController.text.trim().isNotEmpty) {
                                final comment = Comment(
                                  content: _commentController.text.trim(),
                                );
                                Provider.of<TaskProvider>(context, listen: false)
                                    .addComment(widget.task, comment);
                                _commentController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Comments list
                      ...widget.task.comments.map((comment) => Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('MMM dd, HH:mm').format(comment.createTime),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(comment.content),
                              ],
                            ),
                          )).toList().reversed.toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 