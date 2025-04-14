import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ProjectModel.dart';
import "../models/Member.dart";
import '../providers/projectsListProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(CreateProject());
}

class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formKey = GlobalKey<FormState>();
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  final memberNameController = TextEditingController();
  List<Member> members = [];

  DateTimeRange durationRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(Duration(days: 7)),
  );

  @override
  void dispose() {
    projectNameController.dispose();
    projectDescriptionController.dispose();
    memberNameController.dispose();
    super.dispose();
  }

  Future<void> selectDurationRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: durationRange,
      saveText: "Confirm",
    );

    if (picked != null) {
      setState(() {
        durationRange = picked;
      });
    }
  }

  void _addMember() {
    if (memberNameController.text.trim().isNotEmpty) {
      setState(() {
        members.add(Member(name: memberNameController.text.trim()));
        memberNameController.clear();
      });
    }
  }

  void _removeMember(int index) {
    setState(() {
      members.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Project',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: projectNameController,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: projectDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffCFCFCF)),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                child: Row(
                  children: [
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
              SizedBox(height: 30),
              Text(
                "Team Members",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: memberNameController,
                      decoration: InputDecoration(
                        labelText: 'Member Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: _addMember,
                    icon: Icon(Icons.add_circle, size: 30, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (members.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No members added yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: members[index].defaultAvatar,
                      title: Text(members[index].name),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeMember(index),
                      ),
                    );
                  },
                ),
              SizedBox(height: 30),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(300, 46),
                    side: BorderSide(color: Colors.blue, width: 2),
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (members.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please add at least one team member'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final project = Project(
                        projectName: projectNameController.text,
                        durationRange: durationRange,
                        projectDescription: projectDescriptionController.text.trim(),
                        members: members,
                      );

                      Provider.of<ProjectsListProvider>(context, listen: false)
                          .addProject(project);

                      Fluttertoast.showToast(
                        msg: "Project created successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text(
                    'Create Project',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
