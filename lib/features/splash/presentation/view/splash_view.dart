// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:servzz/features/auth/presentation/view/login_view.dart'; // Import LoginView

// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   State<SplashView> createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView> {
//   @override
//   void initState() {
//     super.initState();

//     // Navigate to LoginView after 2 seconds
//     Timer(Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginView()),
//       );
//     });
//   }

//  @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.white,
//     body: Stack(
//       children: [

//         Container(
//           height: MediaQuery.of(context).size.height * 0.5,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/image/login_image.jpg"),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),

//         // Overlapping white card
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.65,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,

//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Let\'s Get Started',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     Navigator.pushReplacement(
//                 //       context,
//                 //       MaterialPageRoute(builder: (context) => LoginView()),
//                 //     );
//                 //   },
//                 //   style: ElevatedButton.styleFrom(
//                 //     backgroundColor: Colors.red[700],
//                 //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                 //     shape: RoundedRectangleBorder(
//                 //       borderRadius: BorderRadius.circular(12),
//                 //     ),
//                 //   ),
//                 //   child: Text(
//                 //     'Start',
//                 //     style: TextStyle(
//                 //       fontSize: 16,
//                 //       color: Colors.white,
//                 //     ),
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/splash/presentation/view_model/splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().init(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // back ground image
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/login_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Bottom container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Image(
                      image: AssetImage('assets/image/servzz_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 30),
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Easy Menu'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
