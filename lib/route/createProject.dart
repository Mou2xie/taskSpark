import 'package:flutter/material.dart';
import "../models/Member.dart";

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

  DateTimeRange _selectedRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));

  final Map<Member, bool> _checkboxes = {
    Member.xie: false,
    Member.sam: false,
    Member.shamshad: false,
    Member.isha: false,
  };

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedRange,
      saveText: "Comfirm",
    );

    if (picked != null) {
      setState(() {
        _selectedRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
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
                  "${_selectedRange!.start.month}.${_selectedRange!.start.day} - ${_selectedRange!.end.month}.${_selectedRange!.end.day}",
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                IconButton(
                    onPressed: () => _selectDateRange(context),
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
          TextFormField(
            maxLines: 4,
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
          ListView(
            shrinkWrap: true,
            children: _checkboxes.keys
                .map((Member member) => CheckboxListTile(
                      value: _checkboxes[member],
                      title: Text(member.name, style: TextStyle(fontSize: 18)),
                      onChanged: (bool? value) {
                        setState(() {
                          _checkboxes[member] = value!;
                        });
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 50),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size(300, 46),
              side: BorderSide(color: Colors.blue, width: 2),
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
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
