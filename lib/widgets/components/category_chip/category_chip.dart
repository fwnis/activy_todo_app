import 'package:flutter/material.dart';
import 'package:todo_app/models/category_model.dart';

class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final ValueChanged<bool> onSelected;
  final bool chipSelected;

  const CategoryChip(
      {super.key,
      required this.category,
      required this.onSelected,
      required this.chipSelected});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: Icon(
        Icons.circle,
        color: category.color,
      ),
      label: Text(category.name),
      selected: chipSelected,
      backgroundColor: category.color.shade100,
      selectedColor: category.color.shade300,
      showCheckmark: true,
      onSelected: onSelected,
      side: const BorderSide(style: BorderStyle.none),
    );
  }
}
