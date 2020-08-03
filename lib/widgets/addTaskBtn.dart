import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/providers/providers.dart';
import 'package:tasker/widgets/addTask.dart';

class AddTaskBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateProvider dateProvider = Provider.of<DateProvider>(context);
    final PriorityProvider priorityProvider =
        Provider.of<PriorityProvider>(context);
    final TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          ),
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AddTask(),
            ),
          ),
          isScrollControlled: true,
        ).then((value) {
          tasksProvider.refresh(
              dateProvider.time, priorityProvider.selectedPriorities);
        });
      },
    );
  }
}
