import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ProjectModel.dart';
import "../models/Member.dart";
import '../providers/projectsListProvider.dart';

void main() {
  runApp(CreateProject());
}

class CreateProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Project',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: FormWidget(),
        ));
  }
}

class FormWidget extends StatefulWidget {
  @override
  createState() {
    return _FormWidgetState();
  }
}

class _FormWidgetState extends State {
  final _formKey = GlobalKey<FormState>();

  // access projectName with projectNameController.text
  final projectNameController = TextEditingController();
  // access projectDescription with projectDescriptionController.text
  final projectDescriptionController = TextEditingController();

  @override
  void dispose() {
    //clean controllers when the widget is removed
    projectNameController.dispose();
    projectDescriptionController.dispose();
    super.dispose();
  }

  // durationRange selected by user
  DateTimeRange durationRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));

  // the member and whether they are enrolled in the project
  Map<Member, bool> enrollMember = {
    Member.xie: false,
    Member.sam: false,
    Member.shamshad: false,
    Member.isha: false,
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

    final projectsListProvider = Provider.of<ProjectsListProvider>(context,listen: false);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // project name input box
          TextFormField(
            controller: projectNameController,
            decoration: InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter project name.';
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
            child: Text("Project Description",
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ),
          SizedBox(height: 5),

          // project description input box
          TextFormField(
            maxLines: 4,
            controller: projectDescriptionController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Team Members",
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ),
          SizedBox(height: 5),

          // team members checkbox
          ListView(
            shrinkWrap: true,
            children: enrollMember.keys
                .map((Member member) => CheckboxListTile(
                      value: enrollMember[member],
                      title: Text(member.name, style: TextStyle(fontSize: 18)),
                      onChanged: (bool? value) {
                        setState(() {
                          enrollMember[member] = value!;
                        });
                      },
                    ))
                .toList(),
          ),

          const SizedBox(height: 50),

          // create btn
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size(300, 46),
              side: BorderSide(color: Colors.blue, width: 2),
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              // check if the form is valid
              if (_formKey.currentState!.validate()) {
                // check if any member is enrolled in the project
                if (enrollMember.values.contains(true)) {

                  // create project object
                  final project = Project(
                    projectName: projectNameController.text,
                    projectDescription: projectDescriptionController.text,
                    durationRange: durationRange,
                    members: enrollMember.entries
                        .where((element) => element.value)
                        .map((e) => e.key)
                        .toList(),
                  );
                  // add project to projectsListProvider
                  projectsListProvider.addProject(project);

                  

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Please put at least one member in the project")),
                  );
                }
              }
            },
            child: const Text(
              'Create',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
