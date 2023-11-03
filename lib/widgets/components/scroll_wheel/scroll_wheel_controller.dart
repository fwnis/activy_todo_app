import 'package:flutter/material.dart';

class ScrollWheelNumber extends StatelessWidget {
  final int time;

  const ScrollWheelNumber({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Center(
        child: Text(
          time < 10 ? '0${time.toString()}' : time.toString(),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class ScrollWheelAmPm extends StatelessWidget {
  final bool isItAm;

  const ScrollWheelAmPm({super.key, required this.isItAm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Center(
        child: Text(
          isItAm ? 'am' : 'pm',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
