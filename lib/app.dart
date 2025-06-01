// Material app

import 'package:flutter/material.dart';
import 'package:servzz/themes/theme_Data.dart';
import 'package:servzz/view/home_page_view.dart';
import 'package:servzz/view/login_view.dart';
import 'package:servzz/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      // main theme of the app 
      // theme as in the customizable themes in androids
      theme: getApplicationTheme(),
      title: "Employee",
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePageView(),
        // '/employee': (context) => const EmployeeView(),
        // '/table': (context) => const HomePage(),
        // '/bottom': (context) => const DashboardScreenView(),
      },
    );
  }
} 