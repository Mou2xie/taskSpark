import 'package:flutter/material.dart';
import 'package:project_manager/route/projectList.dart';

void main() {
  runApp(WelcomePage());
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // show welcome page 3 sec and redirect to ProjectList page
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, promise) {
          if (promise.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // do redirect
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProjectList()),
              );
            });
          }
          
          // welcome page
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/logo.png',
                    scale: 4,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Task Spark',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E6E6E)),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
