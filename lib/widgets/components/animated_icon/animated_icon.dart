import 'package:flutter/material.dart';

class MyAnimatedIcon extends StatefulWidget {
  final Function onPress;
  final bool enabled;
  final IconData icon1;
  final IconData icon2;
  final double? size;

  const MyAnimatedIcon(
      {super.key,
      required this.onPress,
      required this.enabled,
      required this.icon1,
      required this.icon2,
      this.size});

  @override
  State<MyAnimatedIcon> createState() => _MyAnimatedIconState();
}

class _MyAnimatedIconState extends State<MyAnimatedIcon> {
  num _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) => RotationTransition(
          turns: child.key == const ValueKey('icon1')
              ? Tween<double>(begin: 0.75, end: 1).animate(anim)
              : Tween<double>(begin: 1, end: 0.75).animate(anim),
          child: ScaleTransition(
              scale: anim, child: FadeTransition(opacity: anim, child: child)),
        ),
        child: !widget.enabled
            ? Icon(
                widget.icon1,
                key: const ValueKey('icon1'),
                size: widget.size,
              )
            : Icon(
                widget.icon2,
                key: const ValueKey('icon2'),
                size: widget.size,
              ),
      ),
      onPressed: () {
        widget.onPress();
        setState(() {
          _currIndex = _currIndex == 0 ? 1 : 0;
        });
      },
    );
  }
}
