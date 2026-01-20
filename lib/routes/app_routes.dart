import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';

class AppRoutes {
  static const home = '/';

  static final routes = <String, WidgetBuilder>{
    home: (context) => const HomeScreen(),
  };
}
