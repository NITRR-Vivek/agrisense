import 'package:flutter/material.dart';
import '../presentation/home_screen.dart';
import '../presentation/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      home: (context) => const MainScreen(),
    };
  }
}