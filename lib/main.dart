import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/route/welcome.dart';
import 'providers/projectsListProvider.dart';

void main() {
  runApp(
    // wrap the app with ChangeNotifierProvider so I'm able to access projectsProvider everywhere within app
    ChangeNotifierProvider(
      create: (context) => ProjectsListProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Task Spark',
        // the first page is welcome page
        home: WelcomePage());
  }
}
