import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/taskProvider.dart';
import '../models/Member.dart';
import '../models/TaskPriority.dart';
import '../models/TaskModel.dart';
import '../models/ProjectModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateTask extends StatelessWidget {

  final Project project;

  CreateTask({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Task',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TaskForm(project)),
        ));
  }
}

class TaskForm extends StatefulWidget {

  late final Project project;

  TaskForm(Project project) {
    this.project = project;
  }

  @override
  createState() {
    return TaskFormState(project);
  }
}

class TaskFormState extends State<TaskForm> {

  late final Project project;

  final _formKey = GlobalKey<FormState>();

  // access taskName with taskNameController.text
  final taskNameController = TextEditingController();
  final descriptionController = TextEditingController();

  // 存储选中的成员
  late Member assignTo;

  TaskFormState(Project project) {
    this.project = project;
    // 默认选择第一个成员
    assignTo = project.members.first;
  }

  @override
  void dispose() {
    //clean controllers when the widget is removed
    taskNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  //store the priority of the task
  TaskPriority taskPriority = TaskPriority.low;

  // durationRange selected by user
  DateTimeRange durationRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));

  // get duration range from user and set durationRange state
  Future<void> selectDurationRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: durationRange,
      saveText: "Comfirm",
    );

    if (picked != null) {
      setState(() {
        durationRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // task name input box
            TextFormField(
              controller: taskNameController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter task name';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            // task description input box
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),

            SizedBox(height: 20),

            // duration range input box
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffCFCFCF)),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 28),
                  SizedBox(width: 10),
                  Text(
                    "Duration:",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${durationRange.start.month}.${durationRange.start.day} - ${durationRange.end.month}.${durationRange.end.day}",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => selectDurationRange(context),
                    icon: Icon(Icons.date_range, size: 35),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Assign To",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            SizedBox(height: 10),

            // 使用项目成员列表渲染单选按钮
            Column(
              children: project.members.map((member) {
                return RadioListTile<Member>(
                  title: Row(
                    children: [
                      member.defaultAvatar,
                      SizedBox(width: 10),
                      Text(member.name),
                    ],
                  ),
                  value: member,
                  groupValue: assignTo,
                  onChanged: (Member? value) {
                    if (value != null) {
                      setState(() {
                        assignTo = value;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            Text(
              "Priority",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            SizedBox(height: 5),

            // radio list for task priority
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: TaskPriority.values.map((tp) {
                return RadioListTile<TaskPriority>(
                  title: Wrap(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: tp.color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(tp.string,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  value: tp,
                  groupValue: taskPriority,
                  onChanged: (value) {
                    setState(() {
                      taskPriority = value!;
                    });
                  },
                );
              }).toList(),
            ),

            // create btn
            SizedBox(height: 20),

            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(300, 46),
                  side: BorderSide(color: Colors.blue, width: 2),
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Task task = Task(
                      taskName: taskNameController.text,
                      description: descriptionController.text.trim(),
                      duration: durationRange,
                      assignTo: assignTo,
                      priority: taskPriority,
                      status: TaskStatus.notStarted,
                    );

                    taskProvider.addtaskToProject(task, project);

                    // show toast
                    Fluttertoast.showToast(
                      msg: "Task created successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    // after toast shown, jump back to project Detail
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text(
                  'Create Task',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
