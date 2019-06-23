import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String title;
  final Widget trailing;

  const Headline({Key key, @required this.title, this.trailing})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(fontWeight: FontWeight.bold),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
