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

  int convert24HourFormat(int number) {
    if (number > 12) {
      return number - 12;
    } else {
      return number;
    }
  }

  handleTime() {
    final amOrPm = isAm == 0 ? hour : hour + 12;
    final day = addZeroToNumber(NewTaskWidget.date.value.day);
    final month = addZeroToNumber(NewTaskWidget.date.value.month);
    final year = NewTaskWidget.date.value.year;
    final hour2 = addZeroToNumber(amOrPm);
    final minute2 = addZeroToNumber(minute);

    final date = DateTime.parse("$year-$month-$day $hour2:$minute2:00");
    NewTaskWidget.time.value = date;
  }

  int hour = 1;
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
                position:
                    convert24HourFormat(NewTaskWidget.time.value.hour) - 1,
                onSelectedItemChanged: (index) {
                  hour = index + 1;
                },
                childCount: 12,
                child: (context, index) {
                  return ScrollWheelNumber(time: index + 1);
                },
              ),

              // time separator
              const Text(
                ":",
                style: TextStyle(fontSize: 28),
              ),

              // minutes
              ScrollWheel(
                position: NewTaskWidget.time.value.minute ~/ 5 + 1,
                onSelectedItemChanged: (index) {
                  minute = index * 5 - 1;
                },
                childCount: 12,
                child: (context, index) {
                  return ScrollWheelNumber(time: index * 5);
                },
              ),

              // am pm
              ScrollWheel(
                position: NewTaskWidget.time.value.hour > 12 ? 1 : 0,
                onSelectedItemChanged: (index) {
                  isAm = index;
                },
                childCount: 2,
                child: (context, index) {
                  if (index == 0) {
                    return const ScrollWheelAmPm(
                      isItAm: true,
                    );
                  } else {
                    return const ScrollWheelAmPm(
                      isItAm: false,
                    );
                  }
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
