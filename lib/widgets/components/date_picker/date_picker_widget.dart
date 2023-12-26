import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class DatePickerWidget extends StatefulWidget {
  final void Function(DateTime) onDateChange;

  const DatePickerWidget({super.key, required this.onDateChange});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DatePickerController _datePickerController;

  @override
  void initState() {
    super.initState();
    _datePickerController = DatePickerController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _datePickerController.animateToSelection(curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime.now().subtract(const Duration(days: 30)),
      initialSelectedDate: DateTime.now(),
      selectionColor: Theme.of(context).colorScheme.onSurface,
      controller: _datePickerController,
      height: 100,
      monthTextStyle: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade500,
      ),
      dateTextStyle: TextStyle(
        fontSize: 24,
        color: Colors.grey.shade700,
      ),
      dayTextStyle: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade500,
      ),
      onDateChange: widget.onDateChange,
    );
  }
}
