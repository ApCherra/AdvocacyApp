import 'package:coa_progress_tracking_app/auth/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:coa_progress_tracking_app/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  // Initially, show the welcome page
  bool showWelcomePage = true;

  void toggleScreens() {
    setState(() {
      showWelcomePage = !showWelcomePage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showWelcomePage) {
      return WelcomePage(showRegisterPage: toggleScreens);
    }
    else
    {
      return RegisterPage(showWelcomePage: toggleScreens);
    }
  }
}
