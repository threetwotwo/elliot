import 'package:elliot/models/task.dart';
import 'package:elliot/pages/edit_page.dart';
import 'package:elliot/pages/home_page.dart';
import 'package:elliot/view_models/edit_model.dart';
import 'package:elliot/view_models/home_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => HomeModel(),
        ),
        ChangeNotifierProvider(
          builder: (context) => EditModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.blue,
          // Define the default font family.
          fontFamily: 'Futura',
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var editModel = Provider.of<EditModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //reset progress slider
          editModel.updateProgress(0);
          return Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => EditPage(
              task: Task.initial(),
            ),
          ));
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (i) => print(i),
        children: <Widget>[
          Consumer<HomeModel>(
            builder: (context, model, _) {
              model.initTasks();
              return HomePage();
            },
          ),
          Container(
            color: Colors.green,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              onPressed: () {
                print('pressed home');
                setState(() {
                  _pageController.jumpToPage(0);
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.history,
                size: 30,
              ),
              onPressed: () => setState(() {
                print('pressed history');
                _pageController.jumpToPage(1);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
