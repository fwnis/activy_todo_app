import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivyLogo extends StatelessWidget {
  const ActivyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/ACTIVY.svg",
      height: 24,
    );
  }
}
