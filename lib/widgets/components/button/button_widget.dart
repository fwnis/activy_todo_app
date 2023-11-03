import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPress;
  final String title;
  final Color? backgroundColor;
  final bool loading;

  const Button(
      {super.key,
      required this.onPress,
      required this.title,
      this.backgroundColor = Colors.indigo,
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade900,
        padding: const EdgeInsets.all(20),
        minimumSize: const Size.fromHeight(50),
        elevation: 0,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
      ),
      onPressed: loading ? null : onPress,
      child: loading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
    );
  }
}
