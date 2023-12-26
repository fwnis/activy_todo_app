import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/alarm_settings.dart';
import 'package:todo_app/utils/bottom_sheet_controller.dart';
import 'package:todo_app/utils/date_time_round_up.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/lists/category_list/category_list.dart';
import 'package:todo_app/widgets/lists/scroll_wheel_list/alarm_scroll_list.dart';
import 'package:todo_app/widgets/lists/scroll_wheel_list/date_scroll_list.dart';
import 'package:todo_app/widgets/lists/scroll_wheel_list/time_scroll_list.dart';

class NewTaskWidget extends StatefulWidget {
  final String? entityId;
  const NewTaskWidget({super.key, this.entityId});

  static ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());
  static ValueNotifier<bool> useAlarm = ValueNotifier(true);
  static ValueNotifier<int> alarm = ValueNotifier(30);
  static ValueNotifier<Map<String, dynamic>> category = ValueNotifier({});

  @override
  State<NewTaskWidget> createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    if (widget.entityId != null) {
      handleSetTask(widget.entityId);
    }
    super.initState();
  }

  handleSetTask(String? id) async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    final task = await db
        .collection("users")
        .doc(user?.uid)
        .collection("tasks")
        .doc(id)
        .get();

    inputController.text = task["name"];
    NewTaskWidget.date.value = task["date"].toDate();
    NewTaskWidget.useAlarm.value = task["useAlarm"];
    NewTaskWidget.alarm.value = task["alarm"];
    NewTaskWidget.category.value = {
      "categoryName": task["category"]["categoryName"],
      "categoryColor": task["category"]["categoryColor"],
      "categoryId": task["category"]["categoryId"],
    };
  }

  String getTime() {
    var time = NewTaskWidget.date.value;
    var oldTime = alignDateTime(time, const Duration(minutes: 5));
    var formatedTime = DateFormat.Hm().format(oldTime);
    return formatedTime;
  }

  handleNewTask() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final alarmId = Random().nextInt(9999);
    if (inputController.text.isNotEmpty &&
        NewTaskWidget.category.value.isNotEmpty) {
      final collection =
          db.collection("users").doc(user?.uid).collection("tasks");

      if (widget.entityId != null) {
        collection.doc(widget.entityId).update(
          {
            "name": inputController.text,
            "date": NewTaskWidget.date.value,
            "useAlarm": NewTaskWidget.useAlarm.value,
            "alarm": NewTaskWidget.alarm.value,
            "category": NewTaskWidget.category.value,
          },
        );

        final task = await collection.doc(widget.entityId).get().then(
              (value) => value.data(),
            );

        if (NewTaskWidget.useAlarm.value) {
          await Alarm.set(
              alarmSettings: alarmSettings(
                  inputController.text,
                  NewTaskWidget.alarm.value,
                  NewTaskWidget.date.value
                      .subtract(Duration(minutes: NewTaskWidget.alarm.value)),
                  task!["alarmId"]));
        }

        snackMessage("Task edited", Colors.green);
      } else {
        collection.add(
          {
            "name": inputController.text,
            "completed": false,
            "createdAt": Timestamp.now(),
            "date": NewTaskWidget.date.value,
            "useAlarm": NewTaskWidget.useAlarm.value,
            "alarm": NewTaskWidget.alarm.value,
            "alarmId": alarmId,
            "category": NewTaskWidget.category.value,
          },
        );

        if (NewTaskWidget.useAlarm.value) {
          await Alarm.set(
              alarmSettings: alarmSettings(
                  inputController.text,
                  NewTaskWidget.alarm.value,
                  NewTaskWidget.date.value
                      .subtract(Duration(minutes: NewTaskWidget.alarm.value)),
                  alarmId));
        }

        snackMessage("Task added", Colors.green);
      }
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } else if (inputController.text.isEmpty) {
      snackMessage("Your task need a name", Colors.red);
    } else if (NewTaskWidget.category.value.isEmpty) {
      snackMessage("Select or add a category", Colors.red);
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
                  listenable: NewTaskWidget.date,
                  builder: (context, child) => ListTile(
                        onTap: () => bottomSheetController.handleBottomSheet(
                            context, const DateScrollListWidget(), 300),
                        title: Text(
                          DateFormat("d/M/y")
                              .format(NewTaskWidget.date.value)
                              .toString(),
                        ),
                        leading: const Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                        ),
                      )),
              ListenableBuilder(
                  listenable: NewTaskWidget.date,
                  builder: (context, child) {
                    return ListTile(
                      onTap: () => bottomSheetController.handleBottomSheet(
                          context, const TimeScrollListWidget(), 300),
                      title: Text(
                        getTime(),
                      ),
                      enabled: NewTaskWidget.useAlarm.value,
                      leading: const Icon(
                        Icons.alarm,
                        color: Colors.black,
                      ),
                      trailing: Switch(
                        value: NewTaskWidget.useAlarm.value,
                        onChanged: (value) {
                          setState(() {
                            NewTaskWidget.useAlarm.value = value;
                          });
                        },
                      ),
                    );
                  }),
              ListenableBuilder(
                  listenable: NewTaskWidget.alarm,
                  builder: (context, child) {
                    return ListTile(
                      onTap: () => bottomSheetController.handleBottomSheet(
                          context, const AlarmScrollListWidget(), 300),
                      title: Text(
                        "${NewTaskWidget.alarm.value} min before",
                      ),
                      enabled: NewTaskWidget.useAlarm.value,
                      leading: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.black,
                      ),
                    );
                  }),
              ListenableBuilder(
                  listenable: NewTaskWidget.category,
                  builder: (context, child) {
                    return ListTile(
                      onTap: () => bottomSheetController.handleBottomSheet(
                          context, const CategoryListWidget(), 300),
                      title: Text(
                        NewTaskWidget.category.value["categoryName"] ??
                            "Category",
                      ),
                      leading: const Icon(
                        Icons.sell_outlined,
                        color: Colors.black,
                      ),
                    );
                  }),
            ],
          ),
        ),
        Button(
          onPress: () {
            handleNewTask();
          },
          title: widget.entityId != null ? "Edit" : "Add",
          loading: loading,
        ),
      ],
    );
  }
}
