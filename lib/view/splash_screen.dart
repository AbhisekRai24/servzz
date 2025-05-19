// import 'package:flutter/material.dart';
// import 'package:servzz/view/login_view.dart'; // Navigate to login

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Top image
//           Container(
//             height: 300,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/image/login_image.jpg"), // Replace with your image path
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           // Bottom container
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(
//                   top: Radius.circular(30),
//                 ),
//               ),
//               padding: EdgeInsets.all(24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Lets Get Started',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginView()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red[700],
//                       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       'Start',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


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

    // Navigate to LoginView after 2 seconds
    Timer(Duration(seconds: 2), () {
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
                Text(
                  'Let\'s Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(builder: (context) => LoginView()),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.red[700],
                //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //   ),
                //   child: Text(
                //     'Start',
                //     style: TextStyle(
                //       fontSize: 16,
                //       color: Colors.white,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

}

