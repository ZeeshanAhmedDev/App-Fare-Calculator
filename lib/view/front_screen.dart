import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxi_meter/Utils/Button.dart';
import 'package:taxi_meter/Utils/Horizontal%20Cards.dart';
import 'package:taxi_meter/Utils/dialogBox.dart';
import '../Utils/changefare.dart';
import '../Utils/provider.dart';
import 'dart:async';

class FrontScreen extends StatefulWidget {
  const FrontScreen({super.key});

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  Timer? waitTimer;
  Duration waitDuration = const Duration(seconds: 0);

  double totalDistance = 0.0;
  Position? previousPosition;

  late double carSpeed = 0.0;

  String? fairValue = '';

  @override
  void dispose() {
    CustomDialogBox.textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<UserNotifier>(context).getFare().then((value) {
      fairValue = value;
    });
  }

  void startWaitTimer() {
    waitTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      waitDuration += const Duration(seconds: 1);
      setState(() {});
    });
  }

  void stopWaitTimer() {
    waitTimer?.cancel();
    waitTimer = null;
  }

  @override
  void initState() {
    super.initState();
    // Set up the position stream listener
    Geolocator.getPositionStream().listen((position) {
      setState(() {
        carSpeed = position.speed;
      });
    });

    Geolocator.getPositionStream().listen((position) {
      if (previousPosition != null) {
        double distanceInMeters = Geolocator.distanceBetween(
          previousPosition!.latitude,
          previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        setState(() {
          totalDistance += distanceInMeters / 1000; // Convert to kilometers
        });
      }
      previousPosition = position;
    });

    //
    // Set up the position stream listener
    Geolocator.getPositionStream().listen((Position position) {
      carSpeed = position.speed; // Speed in m/s
      if (carSpeed < 2) {
        startWaitTimer();
      } else {
        stopWaitTimer();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChangeFareScreen(),
              ),
            ),
            child: const Icon(
              Icons.save_as_outlined,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text(
            'App Fare Calculator',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Gilroy-ExtraBold',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Column(
            children: [
              //Fare
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardBar(context, 'Fare', '\$ ${fairValue ?? 50}'),
                ],
              ),
              //Distance
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardBar(context, 'Distance',
                      '${totalDistance.toStringAsFixed(2)} km'),
                ],
              ),
              //Wait Time
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardBar(context, 'Wait Time',
                      '${waitDuration.inSeconds} seconds'),
                ],
              ),
              //Speed
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardBar(context, 'Speed',
                      '${(carSpeed * 3.6 >= 2) ? (carSpeed * 3.6).toStringAsFixed(2) : '0.00'} km/h'),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Start or Stop Button
                MyButton(
                    onPressed: () => null,
                    text1: 'Start',
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.9),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
