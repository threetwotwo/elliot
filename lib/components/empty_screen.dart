import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final IconData icon;
  final String title;

  final _color = Colors.grey;

  final String buttonTitle;
  final Function onButtonPressed;

  const EmptyScreen(
      {Key key,
      @required this.title,
      this.icon,
      this.onButtonPressed,
      this.buttonTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            if (icon != null)
//              Icon(
//                icon,
//                color: _color[400],
//                size: 200,
//              ),
//            SizedBox(height: 40),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: _color, fontWeight: FontWeight.w100),
            ),
            SizedBox(height: 60),
            if (buttonTitle != null)
              Material(
                //Wrap with Material
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
                elevation: 10.0,
                color: Colors.black87,
                clipBehavior: Clip.antiAlias, // Add This
                child: MaterialButton(
                  height: 35,
                  color: Colors.black87,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      Text(buttonTitle.toUpperCase(),
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.white)),
                    ],
                  ),
                  onPressed: onButtonPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
