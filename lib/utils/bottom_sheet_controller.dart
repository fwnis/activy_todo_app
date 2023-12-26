import 'package:flutter/material.dart';

class BottomSheetController {
  handleBottomSheet(BuildContext context, Widget child, double height) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        height: height + MediaQuery.of(context).viewInsets.bottom,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}

final bottomSheetController = BottomSheetController();
