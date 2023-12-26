import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/components/button/button_widget.dart';
import 'package:todo_app/widgets/components/category_chip/category_chip.dart';
import 'package:todo_app/widgets/components/new_category_input/new_category_input.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({super.key});

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  int a = 0;

  @override
  void initState() {
    super.initState();
    _stream.get().then((value) => a = value.docs.length);
    for (var i = 0; i < a; i++) {
      _selected.add(false);
    }
  }

  final _stream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("categories")
      .orderBy("createdAt", descending: true);

  final List<bool> _selected = [false];

  _handleSelectChip(
      int index, bool selected, int length, String name, String id, int color) {
    setState(() {
      for (var i = 0; i < length; i++) {
        _selected[i] = false;
      }
      _selected[index] = selected;
    });
    NewTaskWidget.category.value = {
      "categoryName": name,
      "categoryColor": color,
      "categoryId": id,
    };
  }

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: _stream.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(
                      height: snapshot.data!.docs.isEmpty ? 0 : 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> category =
                              snapshot.data!.docs[index].data();
                          _selected.add(false);

                          String id = snapshot.data!.docs[index].reference.id;

                          return CategoryChip(
                            id: id,
                            name: category["name"],
                            color: category["color"],
                            chipSelected:
                                NewTaskWidget.category.value["categoryId"] == id
                                    ? true
                                    : _selected[index],
                            onSelected: (selected) {
                              _handleSelectChip(
                                  index,
                                  selected,
                                  snapshot.data!.docs.length,
                                  category["name"],
                                  id,
                                  category["color"]);
                            },
                          );
                        },
                      ),
                    );
                  }),
              ActionChip(
                backgroundColor: visible ? Colors.red.shade200 : Colors.white,
                label: Text(
                  visible ? "Cancel" : "Add a category",
                  style: TextStyle(
                      color:
                          visible ? Colors.red.shade900 : Colors.grey.shade600),
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
        ),
        NewCategoryInput(
          visible: visible,
        ),
        const SizedBox(
          height: 12,
        ),
        Button(
          onPress: () {
            Navigator.of(context).pop();
          },
          title: "Done",
          loading: false,
        ),
      ],
    );
  }
}
