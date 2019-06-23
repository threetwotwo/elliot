import 'package:elliot/tags/tag.dart';
import 'package:flutter/material.dart';

class TagSticker extends StatelessWidget {
  final double _borderRadius = 5.0;
  final Tag tag;
  final bool showCloseIcon;
  final Function onClose;

  const TagSticker({
    Key key,
    @required this.tag,
    this.showCloseIcon = false,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: this.tag == null ? Colors.transparent : tag.color,
          borderRadius: BorderRadius.circular(_borderRadius)),
      child: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Text(
                this.tag == null ? '' : this.tag.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Futura',
                  color: Colors.white,
                ),
              ),
            ),
            if (showCloseIcon) ...[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: GestureDetector(
                  onTap: onClose,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
