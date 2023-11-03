import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/components/form_input/form_input.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  handleSignIn() async {
    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      snackMessage("Successfully logged in", Colors.green);
    } catch (e) {
      setState(() {
        loading = false;
      });
      snackMessage("Something went wrong, try again", Colors.red);
    }
  }

  snackMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sign In",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        FormInput(
          controller: emailController,
          hint: "Email",
          icon: const Icon(Icons.email),
        ),
        FormInput(
          controller: passwordController,
          hint: "Password",
          icon: const Icon(Icons.lock),
        ),
        const SizedBox(
          height: 12,
        ),
        Button(
          onPress: handleSignIn,
          title: "Sign In",
          loading: loading,
        ),
      ],
    );
  }
}
