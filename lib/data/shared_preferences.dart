import 'package:elliot/models/sort.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  //singleton
  SharedPrefsManager._();
  static final instance = SharedPrefsManager._();

  Future<Sort> getSort() async {
    final prefs = await SharedPreferences.getInstance();
    final title = prefs.getString('sortTitle');
    final desc = prefs.getBool('sortDesc');
    return Sort(title: title, isDescending: desc);
  }

  Future<void> setSort({String title, bool isDesc}) async {
//    final prefs = await SharedPreferences.getInstance();
//    String formattedTitle;
//
//    prefs.setString('sortTitle', title);
//    prefs.setBool('sortDesc', isDesc);
  }
}
