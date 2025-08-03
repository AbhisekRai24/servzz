import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  // main theme of the app
  // theme as in the customizable themes in androids
  return ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.blueGrey[50],
    fontFamily: 'Rufina Bold',

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFA62123),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color.fromARGB(
        255,
        23,
        35,
        53,
      ), // ✅ dark blue background
      selectedItemColor: Colors.white, // ✅ white selected item
      unselectedItemColor: Colors.white70, // ✅ faded white for unselected
      type: BottomNavigationBarType.fixed, // ✅ ensures all items are visible
      elevation: 8, // optional shadow
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: Color(0xFFA62123),
      elevation: 5,
      shadowColor: Colors.black54,
      titleTextStyle: TextStyle(
        fontSize: 15,
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
