import 'package:date_format/date_format.dart';
import 'package:elliot/models/task.dart';
import 'package:elliot/tags/tag_sticker.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final TextStyle _progressStyle = TextStyle(
    color: Colors.deepPurple[900],
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  final TextStyle _titleStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.normal,
//    letterSpacing: 0.3,
  );
  final TextStyle _descriptionStyle = TextStyle(
    color: Colors.grey[600],
    fontSize: 15,
  );

  TaskListItem({Key key, @required this.task}) : super(key: key);
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
                    task.progress.toString() + '%',
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
                                  Text(
                                    formattedDate(task.deadline),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: task.deadline
                                                    .millisecondsSinceEpoch <
                                                DateTime.now()
                                                    .millisecondsSinceEpoch
                                            ? Colors.red[300]
                                            : Colors.grey[600]),
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

String formattedDate(DateTime deadline) {
  final shouldShowYear = deadline.year > DateTime.now().year;
  return formatDate(deadline, [
    M,
    ' ',
    d,
    shouldShowYear ? ', ' : ' ',
    shouldShowYear ? yyyy : '',
  ]).toUpperCase();
}

String formattedTime(DateTime deadline) {
  return formatDate(deadline, [
    h,
    ':',
    nn,
    ' ',
    am,
  ]).toUpperCase();
}
