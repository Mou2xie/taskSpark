import 'package:flutter/material.dart';

class ProjectDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project Detail',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 40),
            onPressed: () {
              // should be a dropdown list
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            TopCard(),
            // list undone
          ],
        ),
      ),
    );
  }
}

class TopCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 138, 138, 138)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text('Project Name', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today),
              Text('1.22 - 2.22',style: TextStyle(fontSize: 18),),
            ],
          ),
          // prople list undone
          Text('This is a project description', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}