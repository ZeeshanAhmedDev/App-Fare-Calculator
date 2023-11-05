import 'package:flutter/material.dart';
import 'package:taxi_meter/view/HomePage.dart';

import 'Utils/Permisson.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Request location permissions before building the app UI
    requestLocationPermission(context);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Fare Calculator',
      home: HomePage(),
    );
  }
}
