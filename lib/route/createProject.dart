import 'package:flutter/material.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
            child: Row(
              children: [
                Icon(
                  Icons.punch_clock_outlined,
                  size: 28,
                ),
                SizedBox(width: 2),
                Text(
                  "Duration:",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(width: 10),
                Text(
                  "${_selectedRange!.start.month}.${_selectedRange!.start.day} - ${_selectedRange!.end.month}.${_selectedRange!.end.day}",
                  style: TextStyle(fontSize: 22),
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
            child: Text("Project Description", style: TextStyle(fontSize: 22)),
          ),
          SizedBox(height: 10),
          TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size(250, 46)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: const Text('Create'),
          )
        ],
      ),
    );
  }
}
