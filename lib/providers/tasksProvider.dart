import 'package:flutter/foundation.dart';
import 'package:tasker/models/db.dart';
import 'package:tasker/models/task.dart';

class TasksProvider extends ChangeNotifier {
  var db;
  Future<List<Task>> _tasks;

  TasksProvider() {
    db = DB();
    _tasks = db.getTasks(DateTime.now(), [0, 1, 2]);
  }

  Future<List<Task>> get tasks => _tasks;

  refresh(DateTime date, List<int> priorities) {
    _tasks = db.getTasks(date, priorities);
    notifyListeners();
  }

  update(int id, Task task) async {
    await db.update(id, task);
  }

  saveagain(Task task) async {
    await db.save(task);
  }

  delete(int id) async {
    await db.delete(id);
  }
}
