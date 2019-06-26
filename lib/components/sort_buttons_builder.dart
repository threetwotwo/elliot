import 'package:elliot/models/sort.dart';
import 'package:flutter/material.dart';

List<String> buttonTitles = [
  'Date added',
  'Progress',
  'Title',
  'Deadline',
  'Tag',
];

class SortButtonBuilder extends StatefulWidget {
  final Sort sort;
  final int itemCount;
  final Function(String, bool) onSelected;
  final Color inactiveColor;
  const SortButtonBuilder({
    Key key,
    this.itemCount,
    this.onSelected,
    this.sort,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  _SortButtonBuilderState createState() => _SortButtonBuilderState();
}

class _SortButtonBuilderState extends State<SortButtonBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: buttonTitles == null ? 0 : buttonTitles.length,
      itemBuilder: (context, index) {
        final buttonTitle = buttonTitles[index];

        return SortButton(
          isDescending: widget.sort.title == buttonTitle
              ? widget.sort.isDescending
              : true,
          isSelected: widget.sort.title == buttonTitle,
          title: buttonTitle,
          inactiveColor: widget.inactiveColor,
          color:
              buttonTitle == widget.sort.title ? Colors.black87 : Colors.white,
          onPressed: (desc) {
            setState(() {
              widget.sort.title = buttonTitle;
//              print('$buttonTitle: desc = $desc');
            });
            widget.onSelected(buttonTitle, desc);
          },
        );
      },
    );
  }
}

class SortButton extends StatefulWidget {
  final String title;
  final Color color;
  final Color inactiveColor;
  final Function(bool) onPressed;
  final bool isSelected;
  final bool isDescending;

  SortButton({
    Key key,
    @required this.title,
    this.color,
    @required this.onPressed,
    this.isSelected,
    this.isDescending = true,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  bool descending;
  @override
  void initState() {
    descending = widget.isDescending;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: FlatButton(
//        padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
        onPressed: () {
          //only toggle descending if already selected
          if (widget.isSelected) setState(() => descending = !descending);
          return widget.onPressed(descending);
        },

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
              color: widget.isSelected ? widget.color : widget.inactiveColor,
              width: widget.isSelected ? 1.5 : 0.7),
        ),
        child: Row(
          children: <Widget>[
            widget.isSelected
                ? Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      descending ? Icons.arrow_downward : Icons.arrow_upward,
                      size: 20,
                    ),
                  )
                : SizedBox(),
            Text(
              widget.isSelected
                  ? this.widget.title.toUpperCase()
                  : this.widget.title.toUpperCase(),
              style: TextStyle(
                  color:
                      widget.isSelected ? widget.color : widget.inactiveColor,
                  fontWeight: widget.isSelected
                      ? FontWeight.normal
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
