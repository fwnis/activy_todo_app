import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Icon icon;

  const FormInput(
      {super.key,
      required this.icon,
      required this.hint,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withAlpha(15),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: hint,
                prefixIcon: icon),
          ),
        ],
      ),
    );
  }
}
