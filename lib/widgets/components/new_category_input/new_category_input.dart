import 'package:flutter/material.dart';

class NewCategoryInput extends StatefulWidget {
  final bool visible;

  const NewCategoryInput({super.key, required this.visible});

  @override
  State<NewCategoryInput> createState() => _NewCategoryInputState();
}

class _NewCategoryInputState extends State<NewCategoryInput> {
  bool row = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        height: widget.visible ? 50 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.visible
            ? Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 30,
                      child: TextField(
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.circle,
                                color: Colors.amber,
                                size: 28,
                              ),
                            ),
                            suffixIcon: InkWell(
                                onTap: () {},
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
