import 'package:date_format/date_format.dart';
import 'package:elliot/models/task.dart';
import 'package:elliot/tags/tag_sticker.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final TextStyle _progressStyle = TextStyle(
    color: Colors.indigo[600],
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  final TextStyle _titleStyle = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontWeight: FontWeight.normal,
//    letterSpacing: 0.3,
  );
  final TextStyle _descriptionStyle = TextStyle(
    color: Colors.grey[600],
    fontSize: 15,
  );

  final bool showProgress;

  TaskListItem({
    Key key,
    @required this.task,
    this.showProgress = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    showProgress
                        ? task.progress.toString() + '%'
                        : formattedDate(task.dateCreated),
                    style: _progressStyle,
                  ),
                  Transform.scale(
                    alignment: Alignment.centerRight,
                    scale: 0.85,
                    child: TagSticker(tag: task.tag),
                  ),
                ],
              ),
            ),
//            Container(
//              height: 1,
//              color: Colors.black45,
//            ),
            Container(
//              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            task.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _titleStyle,
                          ),
                          if (task.description.isNotEmpty)
                            Text(
                              task.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: _descriptionStyle,
                            ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: (task.deadline != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  FittedBox(
                                    child: Text(
                                      formattedDate(task.deadline),
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: task.deadline
                                                      .millisecondsSinceEpoch <
                                                  DateTime.now()
                                                      .millisecondsSinceEpoch
                                              ? Colors.red[300]
                                              : Colors.grey[600]),
                                    ),
                                  ),
                                  Text(
                                    formattedTime(task.deadline),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[400]),
                                  )
                                ],
                              )
                            : SizedBox(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formattedDate(DateTime date) {
  final shouldShowYear = date.year > DateTime.now().year;
  return formatDate(date, [
    M,
    ' ',
    d,
    shouldShowYear ? ', ' : ' ',
    shouldShowYear ? yyyy : '',
  ]).toUpperCase();
}

String formattedTime(DateTime dateTime) {
  return formatDate(dateTime, [
    h,
    ':',
    nn,
    ' ',
    am,
  ]).toUpperCase();
}
