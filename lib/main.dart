import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_manager/route/welcome.dart';
import 'providers/projectsListProvider.dart';
import './providers/taskProvider.dart';
import 'services/token_service.dart';
import 'services/database_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保Flutter引擎初始化
  await TokenService.init();
  await DatabaseService().database; // 初始化数据库
  await ThemeService.init(); // 初始化主题服务
  
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
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = ThemeService.isDarkMode;

  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await ThemeService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Task Spark',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: WelcomePage(),
        );
      },
    );
  }
}
