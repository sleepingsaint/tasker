import 'package:flutter/foundation.dart';

class DateProvider extends ChangeNotifier {
  DateTime _time = DateTime.now();
  DateTime get time => _time;

  set updateTime(DateTime newTime) {
    _time = newTime;
    notifyListeners();
  }
}
