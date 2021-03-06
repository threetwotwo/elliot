import 'package:date_format/date_format.dart';
import 'package:elliot/components/empty_screen.dart';
import 'package:elliot/components/headline.dart';
import 'package:elliot/components/sort_buttons_builder.dart';
import 'package:elliot/components/task_list_item.dart';
import 'package:elliot/data/history_database_manager.dart';
import 'package:elliot/data/home_database_manager.dart';
import 'package:elliot/data/shared_preferences.dart';
import 'package:elliot/models/task.dart';
import 'package:elliot/view_models/edit_model.dart';
import 'package:elliot/view_models/history_model.dart';
import 'package:elliot/view_models/home_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeModel = Provider.of<HomeModel>(context);
    final historyModel = Provider.of<HistoryModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Headline(
          title: 'Tasks',
          trailing: GestureDetector(
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure you want to '
                          'delete all tasks?'),
                      content: Text(
                        'This action cannot be undone.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            HomeDatabase.instance.deleteAll();
                            homeModel.deleteAll();
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
            child: Text(
              formatDate(DateTime.now(), [
                D,
                ', ',
                M,
                ' ',
                d,
              ]).toUpperCase(),
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: homeModel.tasks.isEmpty
            ? EmptyScreen(
                icon: Text(
                  '(◡‿◡✿)',
                  style: TextStyle(fontSize: 40, letterSpacing: 1),
                ),
                title: '️You currently have no tasks.',
                buttonTitle: 'Add new task',
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
                  SizedBox(
                    height: 40,
                    child: SortButtonBuilder(
                      sort: homeModel.savedSort,
                      onSelected: (String buttonTitle, bool desc) {
                        print('$buttonTitle: desc = $desc');
                        SharedPrefsManager.instance
                            .setSort(title: buttonTitle, isDesc: desc);
                        homeModel.sort(title: buttonTitle, descending: desc);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: homeModel.tasks.length,
                        itemBuilder: (context, index) {
                          final Task task = homeModel.tasks[index];
                          return Dismissible(
                            key: Key(task.id.toString()),
                            onDismissed: (direction) {
                              print(direction);
                              //delete task
                              if (direction == DismissDirection.endToStart) {
                                //update UI by updating the view model
                                homeModel.remove(task.id);
                                //update database
                                HomeDatabase.instance.delete(task.id);
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                homeModel.remove(task.id);
                                HomeDatabase.instance.delete(task.id);
                                historyModel.insert(task);
                                HistoryDatabase.instance.insert(task);
                              }
                              setState(() {});
                            },
                            background: Card(
                              child: Container(
                                color: Colors.green,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                            secondaryBackground: Card(
                              child: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Provider.of<EditModel>(context)
                                    .newTask(homeModel.tasks[index]);
                                return Navigator.of(context).push(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => EditPage(
                                      isNew: false,
                                      task: homeModel.tasks[index],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8.0),
                                child: TaskListItem(
                                  task: homeModel.tasks[index],
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
