import 'package:elliot/models/task.dart';
import 'package:elliot/tags/tag.dart';
import 'package:elliot/tags/tag_sticker.dart';
import 'package:flutter/material.dart';

class TaskForm extends StatefulWidget {
  final Tag tag;

  TaskForm({Key key, this.tag}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TagSticker(tag: Tag.tags.first),
//          TextField(
////            controller: _titleController,
//            decoration: InputDecoration.collapsed(hintText: 'hint'),
//            style: Theme.of(context).textTheme.title,
//          ),
          TextFormField(),
        ],
      ),
    );
  }
}
