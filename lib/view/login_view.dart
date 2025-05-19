import 'package:flutter/material.dart';
import 'package:servzz/view/home_page_view.dart';
import 'package:servzz/view/register_view.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:servzz/common/my_snack_bar.dart'; 



class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

   final FocusNode emailFocusNode = FocusNode();
  double emailRotationTurns = 0.0;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        setState(() {
          emailRotationTurns += 1.0; // Rotate 360° each time it gets focused
        });
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
         
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/login_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                     // Email 
                    Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    TextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: AnimatedRotation(
                          turns: emailRotationTurns,
                          duration: Duration(milliseconds: 600),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedMail01,
                            color: Colors.black87,
                            size: 24,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 16),

                    
                    // Password
                    Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSquareLockPassword, color: Colors.black87),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterView()),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showMySnackBar(
                            context: context,
                            message: "Login Successful",
                            color: Colors.green,
                          );

                          
                           Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePageView()),
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA62123),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
