import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/components/scroll_wheel/scroll_wheel_controller.dart';
import 'package:todo_app/widgets/components/scroll_wheel/scroll_wheel_widget.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class DateScrollListWidget extends StatefulWidget {
  const DateScrollListWidget({super.key});

  @override
  State<DateScrollListWidget> createState() => _DateScrollListWidgetState();
}

class _DateScrollListWidgetState extends State<DateScrollListWidget> {
  getMonthDays() {
    return DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
  }

  handleSetDate() {
    final date =
        DateFormat.yMd().parse("$month/$day/${DateTime.now().year + year}");
    NewTaskWidget.date.value = date;
  }

  int month = 1;
  int day = 1;
  int year = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // month
              ScrollWheel(
                position: NewTaskWidget.date.value.month - 1,
                onSelectedItemChanged: (index) {
                  month = index + 1;
                },
                childCount: 12,
                child: (context, index) {
                  return ScrollWheelNumber(time: index + 1);
                },
              ),

              // time separator
              const Text(
                "/",
                style: TextStyle(fontSize: 28),
              ),

              // days
              ScrollWheel(
                position: NewTaskWidget.date.value.day - 1,
                onSelectedItemChanged: (index) {
                  day = index + 1;
                },
                childCount: getMonthDays(),
                child: (context, index) {
                  return ScrollWheelNumber(time: index + 1);
                },
              ),

              const Text(
                "/",
                style: TextStyle(fontSize: 28),
              ),

              // years
              ScrollWheel(
                position: NewTaskWidget.date.value.year - DateTime.now().year,
                onSelectedItemChanged: (index) {
                  year = index;
                },
                width: 80,
                childCount: 11,
                child: (context, index) {
                  return ScrollWheelNumber(time: index + DateTime.now().year);
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
            handleSetDate();
            Navigator.pop(context);
          },
          title: "Set",
          loading: false,
        ),
      ],
    );
  }
}
