import 'package:flutter/material.dart';
import 'package:servzz/common/app_drawer.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Color(0xFFA62123),
      ),
      body: Center(
        child: Text(
          'This is the Menu page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
