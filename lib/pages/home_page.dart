import 'package:date_format/date_format.dart';
import 'package:elliot/components/empty_screen.dart';
import 'package:elliot/components/headline.dart';
import 'package:elliot/components/sort_buttons_builder.dart';
import 'package:elliot/components/task_list_item.dart';
import 'package:elliot/data/home_database_manager.dart';
import 'package:elliot/models/task.dart';
import 'package:elliot/view_models/edit_model.dart';
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
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeModel homeModel = Provider.of<HomeModel>(context);
    final List<Task> tasks = homeModel.tasks;

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
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'.toUpperCase()),
                        ),
                        FlatButton(
                          onPressed: () {
                            HomeDatabase.instance.deleteAll();
                            return Navigator.of(context).pop();
                          },
                          child: Text(
                            'delete'.toUpperCase(),
                            style: TextStyle(color: Colors.red),
                          ),
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
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: tasks.isEmpty
            ? EmptyScreen(
                icon: Icons.adjust,
                title: 'You currently have no tasks.',
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
                      initialSort: 'Date added',
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(tasks[index].id.toString()),
                            onDismissed: (direction) {
                              print(direction);
                              //delete task
                              if (direction == DismissDirection.endToStart) {
                                //update UI by updating the view model
                                homeModel.remove(tasks[index].id);
                                //update database
                                HomeDatabase.instance.delete(tasks[index].id);
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                homeModel.remove(tasks[index].id);
                                HomeDatabase.instance.delete(tasks[index].id);
                                //TODO: move task to another database
                              } else
                                return;
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
                                    .newTask(tasks[index]);
                                return Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => EditPage(
                                              task: tasks[index],
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8.0),
                                child: TaskListItem(
                                  task: tasks[index],
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

class SortByButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;

  SortByButton(
      {Key key, @required this.title, this.color, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.color ?? Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: OutlineButton(
        onPressed: onPressed,
        child: Row(
          children: <Widget>[
            SizedBox(),
            Text(
              this.title,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
