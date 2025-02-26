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
        body: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TaskForm(project)));
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

  TaskFormState(Project project) {
    this.project = project;
  }

  final _formKey = GlobalKey<FormState>();

  // access taskName with taskNameController.text
  final taskNameController = TextEditingController();

  @override
  void dispose() {
    //clean controllers when the widget is removed
    taskNameController.dispose();
    super.dispose();
  }

  //store the member that the task is assigned to
  Member assignTo = Member.xie;

  //store the priority of the task
  Taskpriority taskPriority = Taskpriority.low;

  // durationRange selected by user
  DateTimeRange durationRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));

  // the member available to assign the task to
  Map<Member, String> teamMembers = {
    Member.xie: Member.xie.name,
    Member.sam: Member.sam.name,
    Member.shamshad: Member.shamshad.name,
    Member.isha: Member.isha.name,
  };

  // task priority Enum
  Map<Taskpriority, String> taskPriorities = {
    Taskpriority.high: Taskpriority.high.string,
    Taskpriority.medium: Taskpriority.medium.string,
    Taskpriority.low: Taskpriority.low.string,
  };

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
      child: Column(
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
                return 'Please enter task name.';
              }
              return null;
            },
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
                Icon(
                  Icons.punch_clock_outlined,
                  size: 28,
                ),
                SizedBox(width: 2),
                Text(
                  "Duration:",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                SizedBox(width: 10),
                Text(
                  "${durationRange!.start.month}.${durationRange!.start.day} - ${durationRange!.end.month}.${durationRange!.end.day}",
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                IconButton(
                    onPressed: () => selectDurationRange(context),
                    icon: Icon(
                      Icons.date_range,
                      size: 35,
                    )),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerLeft,
            child: Text("Assign To",
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ),
          SizedBox(height: 5),

          // radio list for team members
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: teamMembers.keys.map((member) {
              return RadioListTile<Member>(
                title: Text(member.name),
                value: member,
                groupValue: assignTo,
                onChanged: (Member? value) {
                  setState(() {
                    assignTo = value!;
                  });
                },
              );
            }).toList(),
          ),

          SizedBox(height: 20),

          Align(
            alignment: Alignment.centerLeft,
            child: Text("Priority",
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ),
          SizedBox(height: 5),

          // radio list for task priority
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: taskPriorities.keys.map((tp) {
              return RadioListTile<Taskpriority>(
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

          SizedBox(height: 50),

          // create btn
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size(300, 46),
              side: BorderSide(color: Colors.blue, width: 2),
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {

                Task task = Task(
                  taskName: taskNameController.text,
                  duration: durationRange,
                  assignTo: assignTo,
                  priority: taskPriority,
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
                      fontSize: 16.0);

                  // after toast shown, jump back to project Detail
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
              }
            },
            child: const Text(
              'Create Task',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
