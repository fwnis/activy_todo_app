import 'package:animated_line_through/animated_line_through.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/date_time_round_up.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class TaskItemWidget extends StatefulWidget {
  final String id;
  final Timestamp date;
  final String name;
  final bool completed;
  final bool pinned;

  const TaskItemWidget(
      {super.key,
      required this.name,
      required this.completed,
      required this.date,
      required this.pinned,
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

  handleDeleteTask() {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    db
        .collection("users")
        .doc(user?.uid)
        .collection("tasks")
        .doc(widget.id)
        .delete();
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
    NewTaskWidget.date.value = DateTime.now().add(Duration(days: 2));
  }

  handlePinTask(bool? val) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    db
        .collection("users")
        .doc(user?.uid)
        .collection("tasks")
        .doc(widget.id)
        .update({"pinned": val});
  }

  late AnimationController _controller;
  late Animation<Offset> _animation;

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
              handlePinTask(!widget.pinned);
              if (!widget.pinned) {
                _handleSnackBar("Task pinned", Colors.indigoAccent, 800);
              } else {
                _handleSnackBar("Task unpinned", Colors.indigoAccent, 800);
              }
            },
            icon: Icons.push_pin_outlined,
            backgroundColor: Colors.indigoAccent,
          ),
          SlidableAction(
            onPressed: (context) {
              _controller.forward();
              Future.delayed(const Duration(milliseconds: 200), () {
                handleDeleteTask();
                _controller.reset();
              });
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
          subtitle: Text(DateFormat("EEEEE, h:mm a")
              .format(alignDateTime(
                  widget.date.toDate(), const Duration(minutes: 5)))
              .toString()),
          leading: const Align(
            alignment: Alignment.center,
            widthFactor: 3,
            child: Icon(
              Icons.circle,
              color: Colors.blue,
              size: 12,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.pinned
                  ? const Icon(
                      Icons.push_pin_outlined,
                      size: 20,
                    )
                  : const SizedBox(),
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
