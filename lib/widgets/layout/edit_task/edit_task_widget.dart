import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/bottom_sheet_controller.dart';
import 'package:todo_app/utils/date_time_round_up.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/lists/category_list/category_list.dart';
import 'package:todo_app/widgets/lists/scroll_wheel_list/alarm_scroll_list.dart';
import 'package:todo_app/widgets/lists/scroll_wheel_list/date_scroll_list.dart';
import 'package:todo_app/widgets/lists/scroll_wheel_list/time_scroll_list.dart';

class EditTaskWidget extends StatefulWidget {
  const EditTaskWidget({super.key});

  static ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());
  static ValueNotifier<DateTime> time = ValueNotifier(DateTime.now());
  static ValueNotifier<int> alarm = ValueNotifier(30);

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  TextEditingController inputController = TextEditingController();

  String getTime() {
    var time = EditTaskWidget.time.value;
    var oldTime = alignDateTime(time, const Duration(minutes: 5));
    var formatedTime = DateFormat.jm().format(oldTime);
    return formatedTime;
  }

  handleNewTask() {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (inputController.text.isNotEmpty) {
      db.collection("users").doc(user?.uid).collection("tasks").doc().set(
        {
          "name": inputController.text,
          "completed": false,
        },
      );
    }
  }

  snackMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
            size: 28,
            color: Colors.grey.shade600,
          ),
        ),
        TextField(
          controller: inputController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Write task here",
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          ),
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.normal),
        ),
        Divider(
          height: 0,
          color: Colors.grey.shade300,
        ),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(
                height: 24,
              ),
              ListenableBuilder(
                  listenable: EditTaskWidget.date,
                  builder: (context, child) => ListTile(
                        onTap: () => bottomSheetController.handleBottomSheet(
                            context, const DateScrollListWidget(), 300),
                        title: Text(
                          DateFormat.yMd()
                              .format(EditTaskWidget.date.value)
                              .toString(),
                        ),
                        leading: const Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                        ),
                      )),
              ListenableBuilder(
                  listenable: EditTaskWidget.time,
                  builder: (context, child) {
                    return ListTile(
                      onTap: () => bottomSheetController.handleBottomSheet(
                          context, const TimeScrollListWidget(), 300),
                      title: Text(
                        getTime(),
                      ),
                      leading: const Icon(
                        Icons.alarm,
                        color: Colors.black,
                      ),
                    );
                  }),
              ListenableBuilder(
                  listenable: EditTaskWidget.alarm,
                  builder: (context, child) {
                    return ListTile(
                      onTap: () => bottomSheetController.handleBottomSheet(
                          context, const AlarmScrollListWidget(), 300),
                      title: Text(
                        "${EditTaskWidget.alarm.value} min before",
                      ),
                      leading: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.black,
                      ),
                    );
                  }),
              ListTile(
                onTap: () => bottomSheetController.handleBottomSheet(
                    context, const CategoryListWidget(), 300),
                title: const Text(
                  "Category",
                ),
                leading: const Icon(
                  Icons.sell_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Button(
          onPress: () {
            handleNewTask();
            Navigator.of(context).pop();
            snackMessage("Task added", Colors.green);
          },
          title: "Add",
          loading: loading,
        ),
      ],
    );
  }
}
