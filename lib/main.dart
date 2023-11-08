import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_meter/view/front_screen.dart';
import 'Utils/Permisson.dart';
import 'Utils/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserNotifier>(
            create: (context) => UserNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Fare Calculator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFF7EC349)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFF7EC349)),
            ),
          ),
        ),
        home: const FrontScreen(),
      ),
    );
  }
}
