import 'package:flutter/material.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/components/category_chip/category_chip.dart';
import 'package:todo_app/widgets/components/new_category_input/new_category_input.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({super.key});

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < lista.length; i++) {
      _selected.add(false);
    }
  }

  List<CategoryModel> lista = [
    CategoryModel(id: "asdasdasd", name: "Important", color: Colors.red),
  ];

  final List<bool> _selected = [];

  _handleSelectChip(CategoryModel category, bool selected) {
    setState(() {
      for (var i = 0; i < lista.length; i++) {
        _selected[i] = false;
      }
      _selected[lista.indexOf(category)] = selected;
    });
  }

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: -8,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: -8,
                    children: lista
                        .map(
                          (category) => CategoryChip(
                            category: category,
                            chipSelected: _selected[lista.indexOf(category)],
                            onSelected: (selected) {
                              _handleSelectChip(category, selected);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  ActionChip(
                    backgroundColor:
                        visible ? Colors.red.shade200 : Colors.white,
                    label: Text(
                      visible ? "Cancel" : "Add a category",
                      style: TextStyle(
                          color: visible
                              ? Colors.red.shade900
                              : Colors.grey.shade600),
                    ),
                    side: const BorderSide(style: BorderStyle.none),
                    avatar: visible
                        ? Icon(
                            Icons.close,
                            color: Colors.red.shade900,
                          )
                        : const Icon(
                            Icons.add,
                            color: Colors.grey,
                          ),
                    onPressed: () {
                      setState(() {
                        visible = !visible;
                      });
                    },
                  ),
                ],
              ),
              NewCategoryInput(
                visible: visible,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Button(
          onPress: () {},
          title: "Set",
          loading: false,
        ),
      ],
    );
  }
}
