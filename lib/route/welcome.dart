import 'package:flutter/material.dart';
import 'package:project_manager/route/login.dart';
import 'package:project_manager/route/projectList.dart';
import 'package:project_manager/services/token_service.dart';

void main() {
  runApp(WelcomePage());
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Show welcome page for 3 seconds and redirect based on token
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, promise) {
          if (promise.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Check if token exists
              final token = TokenService.getToken();
              if (token != null) {
                // Token exists, navigate to project list
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProjectList()),
                );
              } else {
                // No token, navigate to login
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            });
          }
          
          // Welcome page content
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
