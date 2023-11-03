import 'package:flutter/material.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/components/scroll_wheel/scroll_wheel_controller.dart';
import 'package:todo_app/widgets/components/scroll_wheel/scroll_wheel_widget.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class AlarmScrollListWidget extends StatefulWidget {
  const AlarmScrollListWidget({super.key});

  @override
  State<AlarmScrollListWidget> createState() => _AlarmScrollListWidgetState();
}

class _AlarmScrollListWidgetState extends State<AlarmScrollListWidget> {
  int alarm = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // hours
              ScrollWheel(
                position: NewTaskWidget.alarm.value ~/ 5,
                onSelectedItemChanged: (index) {
                  alarm = index * 5;
                },
                childCount: 13,
                child: (context, index) {
                  return ScrollWheelNumber(time: index * 5);
                },
              ),

              const SizedBox(
                width: 4,
              ),

              // time separator
              const Text(
                "min",
                style: TextStyle(fontSize: 28),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Button(
          onPress: () {
            NewTaskWidget.alarm.value = alarm;
            Navigator.of(context).pop();
          },
          title: "Set",
          loading: false,
        ),
      ],
    );
  }
}
