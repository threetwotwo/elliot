import 'package:dotted_border/dotted_border.dart';
import 'package:elliot/tags/tag.dart';
import 'package:elliot/tags/tag_sticker.dart';
import 'package:elliot/view_models/edit_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TagResult extends StatelessWidget {
  final Tag tag;
  final void Function(Tag) onTap;

  const TagResult({Key key, this.tag, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 50,
      child: FittedBox(
        child: GestureDetector(
          onTap: () {
            print(tag.title);
            onTap(this.tag);
          },
          child: TagSticker(
            tag: this.tag,
          ),
        ),
      ),
    );
  }
}

class TagSearch extends StatefulWidget {
  final Function(Tag) onTagSelected;

  const TagSearch({Key key, this.onTagSelected}) : super(key: key);
  @override
  _TagSearchState createState() => _TagSearchState();
}

class _TagSearchState extends State<TagSearch> {
  final _controller = TextEditingController();
  String _criteria = '';
  List<Tag> _results = Tag.tags;

  bool _filter(dynamic v, String c) {
    return v
        .toString()
        .toLowerCase()
        .trim()
        .contains(RegExp(r'' + c.toLowerCase().trim() + ''));
  }

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<EditModel>(context);

    var results = _results.where((result) {
      return _filter(result.title, _criteria);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: TextField(
          onChanged: (value) {
            setState(() {
              _criteria = value;
            });
          },
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration.collapsed(hintText: 'Search'),
          style: Theme.of(context).textTheme.title,
        ),
        actions: _criteria.length == 0
            ? []
            : [
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _controller.text = _criteria = '';
                      });
                    }),
              ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Column(children: [
                DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  gap: 6,
                  padding: EdgeInsets.all(0),
                  child: FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Pick a color!'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                  enableLabel: true,
                                  pickerAreaHeightPercent: 0.8,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Next'.toUpperCase()),
                                  onPressed: () {
                                    setState(() => currentColor = pickerColor);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.add),
                        Text('Add a new tag'.toUpperCase()),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ...results
                    .map((tag) => TagResult(
                          tag: tag,
                          onTap: (tag) {
                            print(tag.title);
                            model.addTag(tag);
                            Navigator.of(context).pop();
                          },
                        ))
                    .toList(),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
