// import 'package:flutter/material.dart';
// import 'package:hugeicons/hugeicons.dart';


// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   final emailController = TextEditingController();
//   final nameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         backgroundColor: Colors.red[700],
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // Go back
//           },
//         ),
//         title: Text(
//           "Register",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[200]),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
              

//               // Email
//               Text("Enter Email", style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 6),
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   hintText: "Enter your email",
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Name
//               Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 6),
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   hintText: "Enter your name",
//                   prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser03, color: Colors.black87),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Password
//               Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 6),
//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSquareLockPassword, color: Colors.black87),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Confirm Password
//               Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 6),
//               TextField(
//                 controller: confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Confirm password",
//                   prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSquareLockPassword, color: Colors.black87),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                 ),
//               ),
//               SizedBox(height: 100),

//               // Register Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
                    
                    
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFA62123),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child: Text("Register", style: TextStyle(fontSize: 18,color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
