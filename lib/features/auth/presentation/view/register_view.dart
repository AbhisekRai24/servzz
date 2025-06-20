import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:servzz/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey[200],
  //     appBar: AppBar(
  //       backgroundColor: Colors.red[700],
  //       elevation: 0,
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back),
  //         onPressed: () {
  //           Navigator.pop(context); // Go back
  //         },
  //       ),
  //       title: Text(
  //         "Register",
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.grey[200],
  //         ),
  //       ),
  //       centerTitle: true,
  //     ),
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Email
  //             Text(
  //               "Enter Email",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 6),
  //             TextField(
  //               controller: emailController,
  //               decoration: InputDecoration(
  //                 hintText: "Enter your email",
  //                 prefixIcon: Icon(Icons.email),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //                 contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //               ),
  //             ),
  //             SizedBox(height: 16),

  //             // Name
  //             // Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
  //             // SizedBox(height: 6),
  //             // TextField(
  //             //   controller: nameController,
  //             //   decoration: InputDecoration(
  //             //     hintText: "Enter your name",
  //             //     border: OutlineInputBorder(
  //             //       borderRadius: BorderRadius.circular(30),
  //             //     ),
  //             //     contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //             //   ),
  //             // ),
  //             // SizedBox(height: 16),

  //             // Password
  //             Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
  //             SizedBox(height: 6),
  //             TextField(
  //               controller: passwordController,
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                 hintText: "Password",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //                 contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //               ),
  //             ),
  //             SizedBox(height: 16),

  //             // Confirm Password
  //             Text(
  //               "Confirm Password",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 6),
  //             TextField(
  //               controller: confirmPasswordController,
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                 hintText: "Confirm password",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //                 contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //               ),
  //             ),
  //             SizedBox(height: 100),

  //             // Register Button
  //             SizedBox(
  //               width: double.infinity,
  //               height: 50,
  //               child: ElevatedButton(
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Color(0xFFA62123),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   "Register",
  //                   style: TextStyle(fontSize: 18, color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        title: Text(
          "Register",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[200],
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<RegisterViewModel, RegisterState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration Successful')),
            );
            // Optionally navigate away after registration
            // Navigator.pop(context);
          }
          if (!state.isSuccess && !state.isLoading) {
            // You might handle failure by showing snackbar if you want,
            // but it is handled inside your bloc by `showMySnackBar` already
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    const Text(
                      "Enter Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter your email';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                          return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Name
                    const Text(
                      "Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter your name';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter your password';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    const Text(
                      "Confirm Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Confirm password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please confirm your password';
                        if (value != passwordController.text)
                          return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<RegisterViewModel>().add(
                                      RegisterUserEvent(
                                        context: context,
                                        username: emailController.text.trim(),
                                        firstName: nameController.text.trim(),
                                        lastName:
                                            '', // add if you have last name field
                                        phone:
                                            '', // add if you have phone field
                                        password:
                                            passwordController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA62123),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child:
                            state.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Register",
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
          );
        },
      ),
    );
  }
}
