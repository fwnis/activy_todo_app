import 'package:flutter/material.dart';

class ScrollWheel extends StatefulWidget {
  final Widget? Function(BuildContext, int) child;
  final int position;
  final double? width;
  final int childCount;
  final void Function(int)? onSelectedItemChanged;

  const ScrollWheel(
      {super.key,
      required this.child,
      required this.childCount,
      this.onSelectedItemChanged,
      required this.position,
      this.width = 50});

  @override
  State<ScrollWheel> createState() => _ScrollWheelState();
}

class _ScrollWheelState extends State<ScrollWheel> {
  FixedExtentScrollController scroll = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      scroll.animateToItem(
        widget.position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ListWheelScrollView.useDelegate(
        onSelectedItemChanged: widget.onSelectedItemChanged,
        itemExtent: 24,
        perspective: 0.005,
        diameterRatio: 1.2,
        controller: scroll,
        useMagnifier: true,
        magnification: 1.5,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: widget.childCount,
          builder: (context, index) {
            return widget.child(context, index);
          },
        ),
      ),
    );
  }
}
