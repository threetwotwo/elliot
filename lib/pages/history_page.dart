import 'package:elliot/components/empty_screen.dart';
import 'package:elliot/components/headline.dart';
import 'package:elliot/components/task_list_item.dart';
import 'package:elliot/data/history_database_manager.dart';
import 'package:elliot/data/home_database_manager.dart';
import 'package:elliot/models/task.dart';
import 'package:elliot/view_models/history_model.dart';
import 'package:elliot/view_models/home_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_page.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final homeModel = Provider.of<HomeModel>(context);
    HistoryModel historyModel = Provider.of<HistoryModel>(context);

    return Scaffold(
      backgroundColor: Colors.green[400],
      appBar: AppBar(
        title: Headline(
          title: 'completed',
          trailing: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure you want to '
                          'clear your history?'),
                      content: Text(
                        'This action cannot be undone.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            HistoryDatabase.instance.deleteAll();
                            historyModel.deleteAll();
                            return Navigator.of(context).pop();
                          },
                          child: Text(
                            'delete'.toUpperCase(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'.toUpperCase()),
                        ),
                      ],
                    );
                  });
            },
            child: Icon(
              Icons.delete,
              size: 24,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: historyModel.tasks.isEmpty
            ? EmptyScreen(
                icon: Text(
                  '🕳️',
                  style: TextStyle(fontSize: 80, color: Colors.white),
                ),
                color: Colors.white,
                title: 'You have not completed anything. \n\n\n   Get to '
                    'work! ',
                onButtonPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => EditPage(
                        task: Task.initial(),
                      ),
                    ),
                  );
                },
              )
            : Column(
                children: <Widget>[
                  SizedBox(height: 20),
//                  SizedBox(
//                    height: 40,
//                    child: SortButtonBuilder(
//                      inactiveColor: Colors.grey[200],
////                      sort: historyModel.savedSort,
////                      initialSort: historyModel.savedSort.title,
//                      onSelected: (String buttonTitle, bool desc) {
//                        print('$buttonTitle: desc = $desc');
//                        SharedPrefsManager.instance
//                            .setSort(title: buttonTitle, isDesc: desc);
//                        historyModel.sort(title: buttonTitle, descending: desc);
//                      },
//                    ),
//                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: historyModel.tasks.length,
                        itemBuilder: (context, index) {
                          final Task task = historyModel.tasks[index];
                          return Dismissible(
                            key: Key(task.id.toString()),
                            onDismissed: (direction) {
                              print(direction);
                              //restore task
                              if (direction == DismissDirection.endToStart) {
                                //update UI by updating the view model
                                homeModel.insert(task);
                                historyModel.remove(task.id);
                                //update database
                                HomeDatabase.instance.insert(task);
                                HistoryDatabase.instance.delete(task.id);
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                historyModel.tasks.remove(task);
                                HistoryDatabase.instance.delete(task.id);
                                //TODO: move task to another database
                              }
                              setState(() {});
                            },
                            background: Card(
                              child: Container(
                                color: Colors.red,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                            secondaryBackground: Card(
                              child: Container(
                                color: Colors.green,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.restore,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
//                                Provider.of<EditModel>(context)
//                                    .newTask(historyModel.tasks[index]);
//                                return Navigator.of(context).push(
//                                  MaterialPageRoute(
//                                    fullscreenDialog: true,
//                                    builder: (context) => EditPage(
//                                      isNew: false,
//                                      task: historyModel.tasks[index],
//                                    ),
//                                  ),
//                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8.0),
                                child: TaskListItem(
                                  showProgress: false,
                                  task: historyModel.tasks[index],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
      ),
    );
  }
}
