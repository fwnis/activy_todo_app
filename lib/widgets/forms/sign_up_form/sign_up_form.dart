import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/components/form_input/form_input.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  final db = FirebaseFirestore.instance;

  handleSignUp() async {
    setState(() {
      loading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      credential.user?.updateDisplayName(nameController.text);
      db.collection("users").doc(credential.user?.uid).set({
        "name": nameController.text,
        "email": credential.user?.email,
      });
      snackMessage("Account successfully created", Colors.green);
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      if (e.code == 'email-already-in-use') {
        snackMessage("Email already in use", Colors.red);
      } else if (e.code == 'weak-password') {
        snackMessage("Weak password. Minimum 6 characters", Colors.red);
      }
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
    nameController.dispose();
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
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 12,
        ),
        FormInput(
          controller: nameController,
          hint: "Name",
          icon: const Icon(Icons.person),
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
          onPress: handleSignUp,
          title: "Create account",
          loading: loading,
        ),
      ],
    );
  }
}
