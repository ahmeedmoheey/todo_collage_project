import 'package:flutter/material.dart';

import '../../auth/login/login.dart';
import '../../auth/regester/regester.dart';
import '../../presentation/screens/home_screen/home_screen.dart';
import '../../presentation/screens/tabs/task_edit/task_edit.dart';

class RoutesManager {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String register = '/register';
  static const String login = '/login';
  static const String edit = '/edit';

  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const Register(),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case edit:
        return MaterialPageRoute(
          builder: (context) => const TaskEdit(),
        );


    }
  }
}