import 'package:elliot/components/empty_screen.dart';
import 'package:elliot/components/headline.dart';
import 'package:elliot/components/sort_buttons_builder.dart';
import 'package:elliot/components/task_list_item.dart';
import 'package:elliot/models/task.dart';
import 'package:elliot/view_models/edit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_page.dart';

class TaskListPage extends StatefulWidget {
  final List<Task> tasks;

  TaskListPage({Key key, this.tasks}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline(
          title: 'Tasks',
          trailing: Icon(Icons.sort_by_alpha),
        ),
      ),
      body: SafeArea(
        child: widget.tasks.isEmpty
            ? EmptyScreen(
                icon: Icons.adjust,
                title: 'You currently have no tasks.',
                buttonTitle: 'Add new task',
                onButtonPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => EditPage()));
                },
              )
            : Column(
                children: <Widget>[
                  SizedBox(height: 20),
//                  Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: Text(
//                      'Sort by:'.toUpperCase(),
//                      style: TextStyle(color: Colors.black),
//                    ),
//                  ),
                  SizedBox(
                    height: 40,
                    child: SortButtonBuilder(
                      initialSort: 'Date added',
                    ),
//                    child: ListView.builder(
//                        scrollDirection: Axis.horizontal,
//                        itemCount: sortButtons.length,
//                        itemBuilder: (context, index) {
//                          return GestureDetector(
//                              onTap: () => sortButtons[index].onPressed,
//                              child: sortButtons[index]);
//                        }),
                  ),
//                  SingleChildScrollView(
//                    scrollDirection: Axis.horizontal,
//                    child: Row(
//                      children: <Widget>[
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                        SortByButton(),
//                      ],
//                    ),
//                  ),
                  SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.tasks.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(widget.tasks[index].id.toString()),
                            onDismissed: (direction) {
                              print(direction);
//                    if (direction == DismissDirection.endToStart)
                              setState(() {
                                widget.tasks.removeAt(index);
                              });
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
                                    .newTask(widget.tasks[index]);
                                return Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => EditPage(
                                              task: widget.tasks[index],
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8.0),
                                child: TaskListItem(
                                  task: widget.tasks[index],
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
  Color color;
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
