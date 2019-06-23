import 'package:elliot/data/database_manager.dart';
import 'package:elliot/models/task.dart';
import 'package:flutter/foundation.dart';

class TaskListModel extends ChangeNotifier {
  List<Task> _tasks = [];

  get tasks => _tasks;

  Future initTasks() async {
    _tasks = await DatabaseManager.instance.getTasks();
    notifyListeners();
  }

  void task(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void remove(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}
