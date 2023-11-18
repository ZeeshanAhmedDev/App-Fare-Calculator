import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class UserNotifier extends ChangeNotifier {
//   storeFare(double data) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setDouble("set_fare", data);
//     notifyListeners();
//   }
//
//   getFare() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final getFare = prefs.getDouble("set_fare");
//     notifyListeners();
//     return getFare;
//   }
// }

class UserNotifier extends ChangeNotifier {
  // Default value for the fare if it's not set
  static const double defaultFare = 30;

  double _fare = defaultFare;

  double get fare => _fare;

  storeFare(double data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("set_fare", data);

    // Update the local variable and notify listeners
    _fare = data;
    notifyListeners();
  }

  Future<double> getFare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Read the fare from SharedPreferences, providing a default value
    final getFare = prefs.getDouble("set_fare") ?? defaultFare;

    // Update the local variable and notify listeners
    _fare = getFare;
    notifyListeners();

    return getFare;
  }
}
