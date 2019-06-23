import 'package:flutter/foundation.dart';

class ProgressModel extends ChangeNotifier {
  double _value = 0.0;

  double get value => _value;

  void newValue(double val) {
    this._value = val;
    notifyListeners();
  }
}
