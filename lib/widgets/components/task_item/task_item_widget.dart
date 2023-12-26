import 'package:alarm/alarm.dart';
import 'package:animated_line_through/animated_line_through.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/bottom_sheet_controller.dart';
import 'package:todo_app/utils/date_time_round_up.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class TaskItemWidget extends StatefulWidget {
  final String id;
  final int? categoryColor;
  final Timestamp date;
  final String name;
  final bool completed;
  final bool useAlarm;
  final int alarmId;

  const TaskItemWidget(
      {super.key,
      required this.name,
      this.categoryColor,
      required this.completed,
      required this.date,
      required this.useAlarm,
      required this.alarmId,
      required this.id});

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget>
    with SingleTickerProviderStateMixin {
  _handleSnackBar(String title, Color color, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(title),
      backgroundColor: color,
      duration: Duration(milliseconds: duration),
    ));
  }

  handleDeleteTask() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final collection =
        db.collection("users").doc(user?.uid).collection("tasks");
    final task = await collection.doc(widget.id).get().then(
          (value) => value.data(),
        );

    await Alarm.stop(task!["alarmId"]);

    collection.doc(widget.id).delete();
  }

  handleCompleteTask(bool? val) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    db
        .collection("users")
        .doc(user?.uid)
        .collection("tasks")
        .doc(widget.id)
        .update({"completed": val});
    _controller.reset();
  }

  _handleSetNewTaskWidget() {}

  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Stream<AlarmSettings> _stream;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isRinging = false;

  String getDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final formatedTime = DateFormat("HH:mm")
        .format(alignDateTime(date, const Duration(minutes: 5)));
    final dateToCheck = date;
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (aDate == today) {
      return widget.useAlarm ? "Today, $formatedTime" : "Today";
    } else if (aDate == yesterday) {
      return widget.useAlarm ? "Yesterday, $formatedTime" : "Yesterday";
    } else if (aDate == tomorrow) {
      return widget.useAlarm ? "Tomorrow, $formatedTime" : "Tomorrow";
    } else {
      return DateFormat("EEEEE, HH:mm")
          .format(alignDateTime(date, const Duration(minutes: 5)));
    }
  }

  bool compareDates(DateTime date) {
    DateTime now = DateTime.now();
    if (now.compareTo(date) > 0 && widget.completed == false) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Slidable(
        endActionPane: ActionPane(motion: const DrawerMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              _controller.forward();
              Future.delayed(const Duration(milliseconds: 200), () {
                handleDeleteTask();
                _controller.reset();
                _handleSnackBar("Task deleted", Colors.red, 800);
              });
            },
            icon: Icons.delete_outline,
            backgroundColor: Colors.red,
          )
        ]),
        startActionPane: ActionPane(motion: const DrawerMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              _handleSetNewTaskWidget();
              bottomSheetController.handleBottomSheet(
                context,
                NewTaskWidget(
                  entityId: widget.id,
                ),
                600,
              );
            },
            icon: Icons.edit,
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
          )
        ]),
        child: ListTile(
          title: AnimatedLineThrough(
            color: Colors.grey,
            duration: const Duration(milliseconds: 150),
            isCrossed: widget.completed,
            child: Text(
              widget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: widget.completed ? Colors.grey : Colors.grey.shade800),
            ),
          ),
          subtitle: Text(
            getDay(widget.date.toDate()),
            style: TextStyle(
                color: compareDates(widget.date.toDate())
                    ? Colors.red
                    : Colors.grey.shade700),
          ),
          leading: Align(
            alignment: Alignment.center,
            widthFactor: 3,
            child: Icon(
              Icons.circle,
              color: Color(widget.categoryColor ?? 11111),
              size: 12,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder(
                stream: null,
                builder: (context, snapshot) {
                  return SizedBox();
                },
              ),
              Checkbox(
                activeColor: Colors.amber,
                value: widget.completed,
                onChanged: (val) {
                  _controller.forward();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    handleCompleteTask(!widget.completed);
                    if (!widget.completed) {
                      _handleSnackBar(
                          "Great work! Task completed.", Colors.green, 800);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
