import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/components/form_input/form_input.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final emailController = TextEditingController();

  bool loading = false;

  handleResetPassword() async {
    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      snackMessage("Email sent, check your inbox", Colors.green);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recovery Password",
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
        const SizedBox(
          height: 12,
        ),
        Button(
          onPress: handleResetPassword,
          title: "Send email",
          loading: loading,
        ),
      ],
    );
  }
}
