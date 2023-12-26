import 'package:flutter/material.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/components/scroll_wheel/scroll_wheel_controller.dart';
import 'package:todo_app/widgets/components/scroll_wheel/scroll_wheel_widget.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class TimeScrollListWidget extends StatefulWidget {
  const TimeScrollListWidget({super.key});

  @override
  State<TimeScrollListWidget> createState() => _TimeScrollListWidgetState();
}

class _TimeScrollListWidgetState extends State<TimeScrollListWidget> {
  String addZeroToNumber(int number) {
    if (number < 10) {
      return "0$number";
    } else if (number == 0) {
      return "00";
    } else {
      return "$number";
    }
  }

  handleTime() {
    final day = addZeroToNumber(NewTaskWidget.date.value.day);
    final month = addZeroToNumber(NewTaskWidget.date.value.month);
    final year = NewTaskWidget.date.value.year;
    final hour2 = addZeroToNumber(hour);
    final minute2 = addZeroToNumber(minute);

    final date = DateTime.parse("$year-$month-$day $hour2:$minute2:00");
    NewTaskWidget.date.value = date;
  }

  int hour = 0;
  int minute = 0;
  int isAm = 0;

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
                position: NewTaskWidget.date.value.hour,
                onSelectedItemChanged: (index) {
                  hour = index;
                },
                childCount: 24,
                child: (context, index) {
                  return ScrollWheelNumber(time: index);
                },
              ),

              // time separator
              const Text(
                ":",
                style: TextStyle(fontSize: 28),
              ),

              // minutes
              ScrollWheel(
                position: NewTaskWidget.date.value.minute ~/ 5,
                onSelectedItemChanged: (index) {
                  minute = index * 5;
                },
                childCount: 12,
                child: (context, index) {
                  return ScrollWheelNumber(time: index * 5);
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Button(
          onPress: () {
            handleTime();
            Navigator.of(context).pop();
          },
          title: "Set",
          loading: false,
        ),
      ],
    );
  }
}
