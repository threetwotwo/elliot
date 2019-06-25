import 'package:date_format/date_format.dart';
import 'package:elliot/components/headline.dart';
import 'package:elliot/components/tag_search.dart';
import 'package:elliot/data/home_database_manager.dart';
import 'package:elliot/models/task.dart';
import 'package:elliot/tags/tag_sticker.dart';
import 'package:elliot/view_models/edit_model.dart';
import 'package:elliot/view_models/progress_model.dart';
import 'package:elliot/view_models/home_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  final Task task;
  final bool isNew;

  const EditPage({Key key, this.task, this.isNew = true}) : super(key: key);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _detailsController = TextEditingController();

  Task currentTask;

  @override
  void initState() {
    Task task = widget.task ?? Task.initial();
    currentTask = task;
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _detailsController.text = task.details;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var editModel = Provider.of<EditModel>(context);
    var homeModel = Provider.of<HomeModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Edit'),
        actions: <Widget>[
          FlatButton(
            onPressed: _titleController.text.isEmpty
                ? null
                : () async {
                    if (_titleController.text.isEmpty) return null;
                    final newTask = currentTask.copyWith(
                      tag: editModel.task.tag,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      details: _detailsController.text,
                      progress: currentTask.progress,
                      deadline: currentTask.deadline,
                    );
                    widget.isNew
                        ? homeModel.insert(newTask)
                        : homeModel.update(id: newTask.id, newTask: newTask);
                    await HomeDatabase.instance.insert(newTask);
                    Navigator.of(context).pop();
                  },
            child: Text(
              'Save'.toUpperCase(),
              style: TextStyle(
                color: _titleController.text.isEmpty
                    ? Colors.grey
                    : Colors.blueAccent,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
//            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                ChangeNotifierProvider<ProgressModel>(
                  builder: (context) => ProgressModel(),
                  child: ProgressSlider(
                    progress: currentTask.progress,
                    onValueChanged: (newValue) {
                      setState(() {
                        currentTask.progress = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),

                Consumer<EditModel>(
                  builder: (context, model, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        (model.task.tag != null)
                            ? GestureDetector(
                                onTap: () => goToTagSearchPage(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Transform.scale(
                                      scale: 1.2,
                                      child: TagSticker(tag: model.task.tag)),
                                ),
                              )
                            : AddTagButton(
                                onPressed: () => goToTagSearchPage(context),
                              ),
                        if (model.task.tag != null)
                          GestureDetector(
                            onTap: () {
                              model.addTag(null);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'remove tag'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                Container(height: 1.5, color: Colors.black),
                SizedBox(height: 20),
                Headline(
                  title: 'task',
                  trailing: null,
                ),
                AddTaskTextField(
//                    autoFocus: true,
                  controller: _titleController,
                  hint: 'Task Name',
                  icon: Icons.adjust,
                ),
                AddTaskTextField(
                  controller: _descriptionController,
                  hint: 'Short Description',
                  icon: Icons.details,
                ),
                SizedBox(height: 20),
                DetailsTextField(
                  controller: _detailsController,
                ),
//                SizedBox(height: 20),
                DeadlinePicker(
                  deadline: currentTask.deadline,
                  onValueChanged: (val) => currentTask.deadline = val,
                  hasDeadline: (val) {
                    if (val == false) {
                      currentTask.deadline = null;
                    }
                  },
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddTagButton extends StatelessWidget {
  final _color = Colors.grey[400];
  final Function onPressed;

  AddTagButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: this.onPressed,
      child: FittedBox(
        child: Container(
          decoration: BoxDecoration(
//            border: Border.all(color: _color),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: _color,
                ),
                Text(
                  'Add a tag'.toUpperCase(),
                  style: TextStyle(color: _color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddTaskTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool autoFocus;

  const AddTaskTextField({
    Key key,
    @required this.controller,
    @required this.hint,
    @required this.icon,
    this.autoFocus = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(icon),
              ),
              Expanded(
                child: TextField(
                  autofocus: this.autoFocus,
                  style: TextStyle(fontSize: 17),
                  textCapitalization: TextCapitalization.sentences,
                  controller: this.controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
            child: Container(
              height: 1,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}

class DeadlinePicker extends StatefulWidget {
  DateTime deadline;
  final Function(DateTime) onValueChanged;
  final Function(bool) hasDeadline;

  DeadlinePicker(
      {Key key, this.deadline, this.onValueChanged, this.hasDeadline})
      : super(key: key);
  @override
  _DeadlinePickerState createState() => _DeadlinePickerState();
}

class _DeadlinePickerState extends State<DeadlinePicker> {
  bool _showPicker;
  @override
  void initState() {
    _showPicker = widget.deadline != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle =
        Theme.of(context).textTheme.subhead.copyWith(color: Colors.grey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Headline(
          title: 'Deadline',
          trailing: Row(
            children: <Widget>[
              CupertinoSwitch(
                activeColor: Colors.greenAccent,
                value: _showPicker,
                onChanged: (val) {
                  setState(() {
                    if (val == false) {
                      print('null it');
//                      deadline = null;
//                      widget.deadline = null;
                      widget.hasDeadline(val);
                    } else {
//                      widget.deadline = DateTime.now();
                    }

                    _showPicker = val;
                  });
                },
              ),
            ],
          ),
        ),
        if (_showPicker && widget.deadline != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              formattedDate(widget.deadline),
              style: _textStyle,
            ),
          ),
        if (_showPicker)
          Container(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: widget.deadline,
                mode: CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: (val) {
                  setState(() {
                    widget.onValueChanged(val);
                  });
                },
              )),
      ],
    );
  }
}

class ProgressSlider extends StatelessWidget {
  final int progress;
  final Function(int) onValueChanged;

  ProgressSlider({Key key, this.progress, this.onValueChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Headline(
          title: 'progress',
          trailing: Text(
            '${progress.toInt()}%',
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
            max: 100,
            value: progress.toDouble(),
            activeColor: Colors.black,
            inactiveColor: Colors.black12,
            onChanged: (val) {
              onValueChanged(val.toInt());
            }),
      ],
    );
  }
}

class DetailsTextField extends StatelessWidget {
  final TextEditingController controller;

  const DetailsTextField({Key key, @required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Headline(
          title: 'details',
          trailing: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Text(
              'done'.toUpperCase(),
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: this.controller,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              labelText: 'Add Details',
              hintStyle: TextStyle(fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[80],
            ),
          ),
        ),
      ],
    );
  }
}

void goToTagSearchPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => TagSearch()));
}

String formattedDate(DateTime deadline) {
  final shouldShowYear = deadline.year != DateTime.now().year;
  final formattedDate = formatDate(deadline, [
    M,
    ' ',
    d,
    shouldShowYear ? ', ' : ' ',
    shouldShowYear ? yyyy : '',
    ' • ',
    h,
    ':',
    nn,
    ' ',
    am,
  ]).toUpperCase();
  return formattedDate;
}
