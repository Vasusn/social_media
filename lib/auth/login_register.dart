import 'package:flutter/material.dart';
import 'package:social_media/Screens/login_screen.dart';
import 'package:social_media/Screens/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(
        onTab: togglePage,
      );
    } else {
      return RegisterScreen(onTab: togglePage);
    }
  }
}
