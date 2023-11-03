import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/components/search_bar/search_bar_widget.dart';
import 'package:todo_app/widgets/components/task_item/task_item_widget.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class TaskListWidget extends StatefulWidget {
  const TaskListWidget({super.key});

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  List<TaskModel> lista = [];

  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("tasks")
      .where("completed", isEqualTo: false)
      .orderBy("pinned", descending: true)
      .orderBy("createdAt", descending: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
  }

  String getDayMonthYear(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  DateTime date = DateTime(NewTaskWidget.date.value.day,
      NewTaskWidget.date.value.month, NewTaskWidget.date.value.year);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable:
            Listenable.merge([SearchBarWidget.search, NewTaskWidget.date]),
        builder: (context, listenable) {
          return StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return ExpansionTile(
                  title: Text("Tasks (${snapshot.data!.docs.length})"),
                  initiallyExpanded: true,
                  shape: const Border(),
                  children: [
                    ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> task = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        String id = snapshot.data!.docs[index].reference.id;
                        if (SearchBarWidget.search.value.isEmpty) {
                          if (task["date"].toDate().toString().contains(
                              getDayMonthYear(NewTaskWidget.date.value))) {
                            return TaskItemWidget(
                              id: id,
                              name: task["name"],
                              completed: task["completed"],
                              date: task["date"],
                              pinned: task["pinned"],
                            );
                          }
                          return TaskItemWidget(
                            id: id,
                            name: task["name"],
                            completed: task["completed"],
                            date: task["date"],
                            pinned: task["pinned"],
                          );
                        }
                        if (task["name"].toString().toLowerCase().contains(
                            SearchBarWidget.search.value.toLowerCase())) {
                          if (task["date"].toDate().toString().contains(
                              getDayMonthYear(NewTaskWidget.date.value))) {
                            return TaskItemWidget(
                              id: id,
                              name: task["name"],
                              completed: task["completed"],
                              date: task["date"],
                              pinned: task["pinned"],
                            );
                          }
                          return TaskItemWidget(
                            id: id,
                            name: task["name"],
                            completed: task["completed"],
                            date: task["date"],
                            pinned: task["pinned"],
                          );
                        }

                        return Container();
                      },
                    )
                  ],
                );
              });
        });
  }
}
