import 'package:flutter/material.dart';
import 'package:gvz/pages/login_page.dart';
import 'package:gvz/pages/reg_page.dart';

class LoginOrRegisterpage extends StatefulWidget {
  const LoginOrRegisterpage({super.key});

  @override
  State<LoginOrRegisterpage> createState() => _LoginOrRegisterpageState();
}

class _LoginOrRegisterpageState extends State<LoginOrRegisterpage> {
  //initially show login page
  bool showLoginPage = true;

  //toggle btw login and reg
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegPage(onTap: togglePages,);
    }
  }
}
