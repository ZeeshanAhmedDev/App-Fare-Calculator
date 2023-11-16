import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends ChangeNotifier {
  storeFare(double data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("set_fare", data);
    notifyListeners();
  }

  getFare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final getFare = prefs.getDouble("set_fare");
    notifyListeners();
    return getFare;
  }
}
