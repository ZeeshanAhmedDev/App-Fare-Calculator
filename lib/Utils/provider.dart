import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends ChangeNotifier {
  storeFare(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("set_fare", data);
    notifyListeners();
  }


  getFare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final getFare = prefs.getString("set_fare");
    notifyListeners();
    return getFare;
  }
}
