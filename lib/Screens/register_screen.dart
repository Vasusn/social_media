import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/button.dart';
import '../component/custom_textfild.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onTab;
  const RegisterScreen({super.key, required this.onTab});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //text edit controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    // ignore: unrelated_type_equality_checks
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      displayMessage("Password don't match!");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (context.mounted) {
        Navigator.pop(context);
      }
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'username': emailController.text.split('@')[0],
        'bio': 'Empty bio...'
      });
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
                Text("Let's create an account for you",
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
                  height: 10,
                ),

                //confirm password textfild
                MyTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: "confirm Password",
                ),

                const SizedBox(
                  height: 25,
                ),

                //signup button
                MyButton(
                  text: "Sign Up",
                  onTab: signUp,
                ),

                const SizedBox(
                  height: 25,
                ),

                //goto register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTab,
                      child: const Text(
                        "Login now",
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
