import 'package:flutter/material.dart';
import 'package:todo_app/utils/bottom_sheet_controller.dart';
import 'package:todo_app/widgets/components/date_picker/date_picker_widget.dart';
import 'package:todo_app/widgets/layout/new_task/new_task_widget.dart';
import 'package:todo_app/widgets/layout/drawer/drawer_widget.dart';
import 'package:todo_app/widgets/layout/header/header_widget.dart';
import 'package:todo_app/widgets/lists/completed_task_list/completed_task_list.dart';
import 'package:todo_app/widgets/lists/task_list/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            const HeaderWidget(),

            const SizedBox(
              height: 18,
            ),

            // date picker
            DatePickerWidget(
              onDateChange: (selectedDate) {
                NewTaskWidget.date.value = selectedDate;
                date = selectedDate;
              },
            ),

            const SizedBox(
              height: 24,
            ),

            // task list
            const TaskListWidget(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                color: Colors.grey.shade200,
              ),
            ),

            //completed task list
            const CompletedTaskListWidget(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NewTaskWidget.date.value = date;
          DateTime time = DateTime.now();
          NewTaskWidget.time.value = time;
          bottomSheetController.handleBottomSheet(
            context,
            const NewTaskWidget(),
            600,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
