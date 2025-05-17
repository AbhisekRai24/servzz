// Material app

import 'package:flutter/material.dart';
import 'package:servzz/view/home_page_view.dart';
import 'package:servzz/view/login_view.dart';
import 'package:servzz/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}