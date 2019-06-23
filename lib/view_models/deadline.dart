import 'package:flutter/foundation.dart';

class Deadline extends ChangeNotifier {
  DateTime _deadline = DateTime.now();

  DateTime get value => _deadline;

  void setNewDeadline(DateTime newVal) {
    this._deadline = newVal;
    notifyListeners();
  }
}
