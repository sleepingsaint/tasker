import 'package:flutter/foundation.dart';

class PriorityProvider extends ChangeNotifier {
  List<int> _selectedPriorities = [];
  List<String> _priorityTags = ["High", "Medium", "Low"];

  List<int> get selectedPriorities => _selectedPriorities;
  List<String> get priorityTags => _priorityTags;

  set updatePriorities(List<int> newPriorites) {
    _selectedPriorities = newPriorites;
    notifyListeners();
  }
}
