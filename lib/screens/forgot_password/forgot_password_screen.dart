import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/screens/signup/signup_screen.dart';
import 'package:todo_app/widgets/components/activy_logo/activy_logo.dart';
import 'package:todo_app/widgets/forms/forgot_password_form/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const ActivyLogo(),
                const SizedBox(
                  height: 12,
                ),
                Lottie.asset("assets/animations/login_animation.json",
                    height: 240),
                const SizedBox(
                  height: 12,
                ),
                const ForgotPasswordForm(),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text("Back"),
                      icon: const Icon(Icons.arrow_back),
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          minimumSize: const Size(12, 12),
                          foregroundColor: Colors.grey.shade900),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ));
                      },
                      label: const Text("Sign Up"),
                      icon: const Icon(Icons.person_add),
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          minimumSize: const Size(12, 12),
                          foregroundColor: Colors.grey.shade900),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
