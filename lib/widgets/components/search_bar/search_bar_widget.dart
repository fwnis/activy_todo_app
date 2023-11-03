import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final bool visible;

  const SearchBarWidget({super.key, required this.visible});

  static ValueNotifier<String> search = ValueNotifier("");


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(10),
        borderRadius: BorderRadius.circular(50),
      ),
      height: visible ? 50 : 0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      child: visible
          ? TextField(
              onChanged: (value) {
                search.value = value;
              },
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              ),
            )
          : Container(),
    );
  }
}
