import 'package:elliot/models/task.dart';
import 'package:elliot/pages/edit_page.dart';
import 'package:elliot/pages/task_list_page.dart';
import 'package:elliot/view_models/edit_model.dart';
import 'package:elliot/view_models/task_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

final GlobalKey tabBarGlobalKey = GlobalKey();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => TaskListModel(),
        ),
        ChangeNotifierProvider(
          builder: (context) => EditModel(),
        ),
        Provider(builder: (context) => tabBarGlobalKey),
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
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();

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
          Consumer<TaskListModel>(
            builder: (context, model, _) {
              return TaskListPage(tasks: model.tasks);
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
//      bottomNavigationBar: BottomAppBar(
//        key: tabBarGlobalKey,
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(icon: Icon(Icons.home)),
//          BottomNavigationBarItem(icon: Icon(Icons.add)),
//          BottomNavigationBarItem(icon: Icon(Icons.history)),
//        ],
//      ),
//      tabBuilder: (context, index) {
//        assert(index >= 0 && index <= 2);
//        switch (index) {
//          case 0:
//            return CupertinoTabView(builder: (context) {
//              return Consumer<TaskListModel>(builder: (context, model, _) {
//                return TaskListPage(
//                  tasks: model.tasks,
//                );
//              });
//            });
//          case 1:
//            return CupertinoTabView(
//              builder: (context) => Container(
//                color: Colors.blue,
//                child: EditPage(),
//              ),
//            );
//          case 2:
//            return CupertinoTabView(
//              builder: (context) => Container(
//                color: Colors.green,
//              ),
//            );
//        }
//        return null;
//      },
    );
  }
}
