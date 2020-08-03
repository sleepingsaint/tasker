import 'package:flutter/foundation.dart';
import 'package:tasker/models/task.dart';

class DeletedTaskProvider extends ChangeNotifier {
  Task _deletedTask;

  Task get deletedTask => _deletedTask;

  set updateDeletedTask(Task newDeletedTask) {
    _deletedTask = newDeletedTask;
    notifyListeners();
  }
}
