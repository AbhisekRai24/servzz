import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  // main theme of the app 
  // theme as in the customizable themes in androids
  return ThemeData(
        useMaterial3 : false,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.blueGrey,
        fontFamily: 'Rufina Bold',

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 30,
              color: Colors.greenAccent,
              fontWeight: FontWeight.w600,
              ),
            backgroundColor: Color(0xFFA62123),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
               ),

            
          ),
        ),


        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Color(0xFFA62123),
          elevation: 5,
          shadowColor: Colors.black54,
          titleTextStyle: TextStyle(
            fontSize: 15,
            color : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

      );
}