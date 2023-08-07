import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/button.dart';
import '../component/custom_textfild.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onTab;
  const LoginScreen({super.key, required this.onTab});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text edit controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(
                  height: 50,
                ),

                //welcome msg
                Text("Welcome back, you've been missed!",
                    style: TextStyle(color: Colors.grey[700])),

                const SizedBox(
                  height: 25,
                ),

                //email textfild
                MyTextField(
                  controller: emailController,
                  obscureText: false,
                  hintText: "Email",
                ),

                const SizedBox(
                  height: 10,
                ),

                //password textfild
                MyTextField(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Password",
                ),

                const SizedBox(
                  height: 25,
                ),

                //signin button
                MyButton(
                  text: "Sign In",
                  onTab: signIn,
                ),

                const SizedBox(
                  height: 25,
                ),

                //goto register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTab,
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
