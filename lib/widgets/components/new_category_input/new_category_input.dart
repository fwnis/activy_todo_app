import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';

class NewCategoryInput extends StatefulWidget {
  final bool visible;

  const NewCategoryInput({super.key, required this.visible});

  @override
  State<NewCategoryInput> createState() => _NewCategoryInputState();
}

class _NewCategoryInputState extends State<NewCategoryInput> {
  TextEditingController inputController = TextEditingController();

  handleNewCategory() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    if (inputController.text.isNotEmpty) {
      String id = "";
      await db.collection("users").doc(user?.uid).collection("categories").add(
        {
          "name": inputController.text,
          "color": selected[index].value,
          "createdAt": Timestamp.now(),
        },
      ).then((value) => id = value.id);
      NewTaskWidget.category.value = {
        "categoryName": inputController.text,
        "categoryColor": selected[index].value,
        "categoryId": id
      };
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

  MaterialColor getMaterialColor(Color color) {
    final Map<int, Color> shades = {
      50: const Color.fromRGBO(136, 14, 79, .1),
      100: const Color.fromRGBO(136, 14, 79, .2),
      200: const Color.fromRGBO(136, 14, 79, .3),
      300: const Color.fromRGBO(136, 14, 79, .4),
      400: const Color.fromRGBO(136, 14, 79, .5),
      500: const Color.fromRGBO(136, 14, 79, .6),
      600: const Color.fromRGBO(136, 14, 79, .7),
      700: const Color.fromRGBO(136, 14, 79, .8),
      800: const Color.fromRGBO(136, 14, 79, .9),
      900: const Color.fromRGBO(136, 14, 79, 1),
    };
    return MaterialColor(color.value, shades);
  }

  final List<MaterialColor> selected = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.amber,
    Colors.orange,
    Colors.red,
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        height: widget.visible ? 50 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: selected[index].shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.visible
            ? Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 30,
                      child: TextField(
                        controller: inputController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            prefixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  if (index < selected.length - 1) {
                                    index++;
                                  } else {
                                    index = 0;
                                  }
                                });
                                print(getMaterialColor(
                                    Color(selected[index].value)));
                                print(index);
                              },
                              child: Icon(
                                Icons.circle,
                                color: selected[index],
                                size: 28,
                              ),
                            ),
                            suffixIcon: InkWell(
                                onTap: () {
                                  if (inputController.text.isNotEmpty) {
                                    handleNewCategory();
                                    Navigator.of(context).pop();
                                    snackMessage(
                                        "Category created", Colors.green);
                                  }
                                },
                                child: const Icon(
                                  Icons.check,
                                )),
                            fillColor: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              )
            : Container());
  }
}
