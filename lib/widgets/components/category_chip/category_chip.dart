import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/utils/get_material_color.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class CategoryChip extends StatefulWidget {
  final String id;
  final String name;
  final int color;
  final ValueChanged<bool> onSelected;
  final bool chipSelected;

  const CategoryChip(
      {super.key,
      required this.id,
      required this.name,
      required this.color,
      required this.onSelected,
      required this.chipSelected});

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  late MaterialColor categoryColor;

  @override
  void initState() {
    super.initState();
    categoryColor = getMaterialColor(Color(widget.color));
  }

  handleDeleteTask() {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    db
        .collection("users")
        .doc(user?.uid)
        .collection("categories")
        .doc(widget.id)
        .delete();
    NewTaskWidget.category.value = {};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onLongPress: handleDeleteTask,
        child: ChoiceChip(
          avatar: Icon(
            Icons.circle,
            color: categoryColor,
          ),
          label: Text(widget.name),
          selected: widget.chipSelected,
          backgroundColor: categoryColor.shade100,
          selectedColor: categoryColor.shade300,
          showCheckmark: true,
          onSelected: widget.onSelected,
          side: const BorderSide(style: BorderStyle.none),
        ),
      ),
    );
  }
}
