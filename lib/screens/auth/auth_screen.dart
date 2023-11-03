import 'package:flutter/material.dart';
import 'package:todo_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:todo_app/screens/signin/signin_screen.dart';
import 'package:todo_app/screens/signup/signup_screen.dart';
import 'package:todo_app/screens/splash/splash_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        ForgotPasswordScreen(),
        SignUpScreen(),
        SignInScreen(),
        SplashScreen(),
      ],
    );
  }
}
