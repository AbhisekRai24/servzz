
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:servzz/view/login_view.dart'; // Import LoginView

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate 
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        
        Container(
          height: MediaQuery.of(context).size.height * 0.5, 
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/login_image.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Overlapping white card
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.65,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   Image.asset(
                    'assets/image/servzz_logo.png', 
                    height: 100,
                    width: 100,
                  ),
                   SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

}

