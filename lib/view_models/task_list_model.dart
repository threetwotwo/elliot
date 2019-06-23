import 'package:elliot/models/task.dart';
import 'package:flutter/foundation.dart';

class TaskListModel extends ChangeNotifier {
  final List<Task> _tasks = [];

  get tasks => _tasks;

  void task(Task task) {
    _tasks.add(task);
    notifyListeners();
  }
}
