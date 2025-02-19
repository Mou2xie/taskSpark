import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/route/welcome.dart';
import 'providers/projectsListProvider.dart';
import './providers/taskProvider.dart';

void main() {
  runApp(
    // wrap the app with MultiProvider so I'm able to access states everywhere within app
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProjectsListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
