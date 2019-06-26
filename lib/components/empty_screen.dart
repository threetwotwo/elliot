import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final Widget icon;
  final String title;

  final Color color;

  final String buttonTitle;
  final Function onButtonPressed;

  const EmptyScreen({
    Key key,
    @required this.title,
    this.icon,
    this.onButtonPressed,
    this.buttonTitle,
    this.color = Colors.black87,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height -
            kToolbarHeight -
            kBottomNavigationBarHeight,
        child: Center(
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) icon,
              Container(
                height: 60,
//              color: Colors.red,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: color, fontWeight: FontWeight.w100),
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
      ),
    );
  }
}
