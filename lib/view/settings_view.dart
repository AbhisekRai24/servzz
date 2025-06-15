import 'package:flutter/material.dart';
import 'package:servzz/common/app_drawer.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      drawer: const AppDrawer(),
     
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFFA62123),
      ),
      body: Center(
        child: Text(
          'This is Settings',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}