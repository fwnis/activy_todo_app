import 'package:flutter/material.dart';

class BottomSheetController {
  handleBottomSheet(BuildContext context, Widget child, double height) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          height: height,
          child: child,
        ),
      ),
    );
  }
}

final bottomSheetController = BottomSheetController();
