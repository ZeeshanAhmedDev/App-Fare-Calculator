import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
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
  //audio player
  void playSound(String url) async {
    AssetsAudioPlayer.newPlayer().open(Audio(url), autoStart: true);
  }

  late double carSpeed = 0.0;

  /// to know car speed
  bool isCalculatingSpeed = false;

  /// to reset car speed to zero

  double totalFare = 0.0;

  double totalDistance = 0.0;
  Duration waitDuration = const Duration(seconds: 0);
  bool isCalculating = false;
  DateTime? startTime;

  @override
  void dispose() {
    CustomDialogBox.textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Provider.of<UserNotifier>(context).getFare().then((value) {
    //   totalFare = value;
    // });
  }

  // carSpeed Function
/*  Future<void> calculateSpeed() async {
    // Set up the position stream listener
    Geolocator.getPositionStream().listen((position) {
      setState(() {
        carSpeed = position.speed;
      });
    });
    //   Position position = await Geolocator.getCurrentPosition(

    // try {
    //       desiredAccuracy: LocationAccuracy.best);
    //   setState(() {
    //     // Speed is in m/s, you can convert it to km/h by multiplying by 3.6
    //     carSpeed = position.speed;
    //     setState(() {});
    //   });
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("Error getting position: $e");
    //   }
    // }
  }*/

  @override
  void initState() {
    super.initState();
    // Set up the position stream listener
    /*   Geolocator.getPositionStream().listen((position) {
      setState(() {
        carSpeed = position.speed;
      });
    });*/

    // Distance Calculation
/*    Geolocator.getPositionStream().listen((position) {
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
    });*/

    // Set up the position stream listener
    /*   Geolocator.getPositionStream().listen((Position position) {
      carSpeed = position.speed; // Speed in m/s
      if (carSpeed < 2) {
        startWaitTimer();
      } else {
        stopWaitTimer();
      }
      setState(() {});
    });*/
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
          Column(
            children: [
              //Fare
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardBar(
                      context, 'Fare', '\$ ${totalFare.toStringAsFixed(2)}'),
                ],
              ),
              //Distance
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardBar(
                      context, 'Distance', '${waitDuration.inSeconds} seconds'),
                ],
              ),
              //Wait Time
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardBar(context, 'Wait Time', '00'),
                ],
              ),
              //Speed
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* isCalculatingSpeed == false
                      ? cardBar(context, 'Speed', 'FOR HIRE')
                      : carSpeed == 0.0
                      ? cardBar(context, 'Speed', 'STOPPED')
                      : */
                  cardBar(context, 'Speed',
                      '${(carSpeed * 3.6 >= 0.5) ? (carSpeed * 3.6).toStringAsFixed(2) : '0.00'} km/h'),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      toggleTaximeter();
                      if (!isCalculatingSpeed) {
                        isCalculatingSpeed = true;
                        playSound('assets/audio/start.mp3');
                      } else {
                        isCalculatingSpeed = false;
                        playSound('assets/audio/stop.mp3');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          isCalculatingSpeed ? Colors.red : Colors.green,
                    ),
                    child: Text(
                      isCalculatingSpeed ? 'STOP' : 'START',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.06,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateTaximeter() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest);

      setState(() {
        double newSpeed = position.speed ?? 0.0;
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          position.latitude,
          position.longitude,
        );

        if (startTime == null) {
          startTime = DateTime.now();
        }

        if (newSpeed > 0.0) {
          carSpeed = newSpeed;
        }

        if (isCalculatingSpeed) {
          totalDistance += distance;
          calculateFare();
        }
      });
    } catch (e) {
      print("Error getting position: $e");
    }
  }

  void toggleTaximeter() {
    setState(() {
      if (isCalculatingSpeed) {
        stopTaximeter();
      } else {
        startTaximeter();
      }
    });
  }

  void startTaximeter() {
    setState(() {
      isCalculatingSpeed = true;
      startTime = DateTime.now();
      totalDistance = 0.0;
      totalFare = 0.0;
      carSpeed = 0.0;

      // Start updating taximeter every second
      Timer.periodic(Duration(seconds: 1), (timer) {
        updateTaximeter();
      });
    });
  }

  void stopTaximeter() {
    setState(() {
      isCalculatingSpeed = false;
      startTime = null;
    });
  }

  void calculateFare() {
    DateTime now = DateTime.now();
    Duration duration = now.difference(startTime!);
    int hours = duration.inSeconds;

    // Hourly rate is $50
    totalFare = hours * 50.0;
  }
}
