import 'package:flutter/material.dart';

List<String> buttonTitles = [
  'Date added',
  'Progress',
  'Title',
  'Deadline',
  'Tag',
];

class SortButtonBuilder extends StatefulWidget {
  final String initialSort;
  final int itemCount;
  final Function(String, bool) onSelected;
  const SortButtonBuilder({
    Key key,
    this.initialSort,
    this.itemCount,
    this.onSelected,
  }) : super(key: key);

  @override
  _SortButtonBuilderState createState() => _SortButtonBuilderState();
}

class _SortButtonBuilderState extends State<SortButtonBuilder> {
  String selectedSort;

  @override
  void initState() {
    selectedSort = widget.initialSort;
    print('initial: $selectedSort');
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
          isSelected: selectedSort == buttonTitle,
          title: buttonTitle,
          color: buttonTitle == selectedSort ? Colors.black87 : Colors.white,
          onPressed: (desc) {
            setState(() {
              selectedSort = buttonTitle;
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
  final Function(bool) onPressed;
  final bool isSelected;

  SortButton({
    Key key,
    @required this.title,
    this.color,
    @required this.onPressed,
    this.isSelected,
  }) : super(key: key);

  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  bool descending = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
              color: widget.isSelected ? widget.color : Colors.grey[300],
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
                  color: widget.isSelected ? widget.color : Colors.grey[300],
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
