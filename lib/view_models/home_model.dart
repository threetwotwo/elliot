import 'package:elliot/data/home_database_manager.dart';
import 'package:elliot/models/task.dart';
import 'package:flutter/foundation.dart';

class HomeModel extends ChangeNotifier {
  List<Task> _tasks = [];

  HomeModel._();

  static Future<HomeModel> create() async {
    HomeModel model = HomeModel._();
    model.initTasks();
    //    await calendar._addHalfDays();
    //    await calendar._addVacations();
    //    await calendar._addTimes();
    return model;
  }

  get tasks => _tasks;

  Future initTasks() async {
    print('initTasks()');
    _tasks = await HomeDatabase.instance.getTasks();
    notifyListeners();
  }

  void deleteAll() {
    _tasks.clear();
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  void insert(Task newTask) {
    _tasks.add(newTask);
    notifyListeners();
  }

  void update({String id, Task newTask}) {
    var index = _tasks.indexWhere((task) => task.id == id);
    if (index != null) _tasks[index] = newTask;

//    print(newTask.title);
    notifyListeners();
  }

  void remove(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

//  void compare() {
//    var data = Collection<Task>
//  }

  void sort({String title, bool descending}) {
    print('sort');
    int Function(Task, Task) compare;

    if (descending) {
      switch (title.toLowerCase()) {
        case 'date added':
          compare = (a, b) => b.dateCreated.compareTo(a.dateCreated);
          break;
        case 'progress':
          compare = (Task a, Task b) => b.progress.compareTo(a.progress);
          break;
        case 'title':
          compare = (Task a, Task b) => b.title.compareTo(a.title);
          break;
        case 'tag':
          compare = (Task a, Task b) {
            if (a.tag == null || b.tag == null) return 0;
            return b.tag.title.compareTo(a.tag.title);
          };
          break;
        case 'deadline':
          compare = (Task a, Task b) {
            if (a.deadline == null || b.deadline == null) return 100000;
            return b.deadline.compareTo(a.deadline);
          };
          break;
      }
    } else {
      switch (title.toLowerCase()) {
        case 'date added':
          compare = (a, b) => a.dateCreated.compareTo(b.dateCreated);
          break;
        case 'progress':
          compare = (Task a, Task b) => a.progress.compareTo(b.progress);
          break;
        case 'title':
          compare = (Task a, Task b) => a.title.compareTo(b.title);
          break;
        case 'tag':
          compare = (Task a, Task b) {
            if (a.tag == null || b.tag == null) return 100000;
            return a.tag.title.compareTo(b.tag.title);
          };
          break;
        case 'deadline':
          compare = (Task a, Task b) {
            if (a.deadline == null || b.deadline == null) return 0;
            return a.deadline.compareTo(b.deadline);
          };
          break;
      }
    }

    _tasks.sort((Task a, Task b) => compare(a, b));

    notifyListeners();
  }
}
