import 'package:elliot/models/task.dart';
import 'package:elliot/tags/tag.dart';
import 'package:flutter/foundation.dart';

class EditModel extends ChangeNotifier {
  Task _task = Task.initial();
  Task get task => _task;

  void newTask(Task task) {
    _task = task;
    notifyListeners();
  }

  void addTag(Tag newTag) {
    _task = _task.copyWith(tag: newTag);
    notifyListeners();
  }

  void updateProgress(int val) {
    _task = _task.copyWith(progress: val);
    notifyListeners();
  }
}
