import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/widgets/components/animated_icon/animated_icon.dart';
import 'package:todo_app/widgets/components/search_bar/search_bar_widget.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool visible = false;
  bool isPlaying = false;

  getWeekMonthDay() {
    return DateFormat.MMMMEEEEd().format(DateTime.now()).toString();
  }

  handleSearch() {
    setState(() {
      visible = !visible;
      SearchBarWidget.search.value = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getWeekMonthDay(),
              style: TextStyle(color: Colors.grey.shade600)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "To-Do List",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              MyAnimatedIcon(
                onPress: handleSearch,
                enabled: visible,
                icon1: Icons.search,
                icon2: Icons.close,
              ),
            ],
          ),
          SearchBarWidget(visible: visible)
        ],
      ),
    );
  }
}
