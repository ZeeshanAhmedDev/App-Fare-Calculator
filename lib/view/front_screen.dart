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
import 'package:flutter_tts/flutter_tts.dart';

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

  FlutterTts flutterTts = FlutterTts();

  var totalPrice;

  late StreamSubscription _getPositionSubscription;

  late double carSpeed = 0.0;
  //covered distance variable
  double coveredDistance = 0.0;

  Position? previousPosition;

  /// to know car speed
  bool isCalculatingSpeed = false;

  /// to reset car speed to zero

  double totalFare = 30;
  double ratePerKilometer = 2;

  // ------------------- calculate waiting time when the car stationary
  Timer? waitTimer;
  Duration waitDuration = const Duration(seconds: 0);

  int seconds = 0;
  Timer? timer;

// ------------------- calculate waiting time when the car stationary

  // bool isCalculating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // CustomDialogBox.textEditingController.dispose();
    // Stop listening to location changes when the widget is disposed
    _getPositionSubscription.cancel();

    // Cancel the timer when the widget is disposed
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserNotifier>(context).getFare().then((value) {
      totalFare = value;
    });
  }

  void calculateDistance() {
    setState(() {
      previousPosition = null; // Reset previous position
    });

    positionStreamForDistance =
        Geolocator.getPositionStream().listen((Position position) {
      if (previousPosition != null) {
        double distance = Geolocator.distanceBetween(
          previousPosition!.latitude,
          previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        // Convert distance from meters to kilometers
        double distanceInKms = distance / 1000;

        setState(() {
          coveredDistance += distanceInKms;
        });
      }

      previousPosition = position;
    });
  }

  StreamSubscription<Position>? positionStream;
  StreamSubscription<Position>? positionStreamForDistance;

  // carSpeed Function
  Future<void> calculateSpeed() async {
    // Set up the position stream listener

    _getPositionSubscription =
        Geolocator.getPositionStream().listen((position) {
      setState(() {
        carSpeed = position.speed;
      });
    });

    if (carSpeed < 1.5) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  void stopTimerOnStopButton() {
    if (!isCalculatingSpeed) {
      if (timer != null) {
        timer!.cancel();
      }
    }
  }

  void disposePositionStream() {
    positionStream?.cancel();
    positionStream = null;
  }

  /// ----------------------------------- WAIT TIME

  void startTimer() {
    // If a timer is already running, cancel it
    if (timer != null) {
      timer!.cancel();
    }

    // Start a new timer that increments every second
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    // Stop the timer and reset the seconds to zero
    if (timer != null) {
      timer!.cancel();
      setState(() {
        seconds = 0;
      });
    }
  }
/*  void startWaitTimer() {
    if (kDebugMode) {
      print('startWaitTimer called');
    }
    waitTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        waitDuration += const Duration(seconds: 1);
      });
    });
  }*/

/*  void stopWaitTimer() {
    setState(() {
      waitTimer?.cancel();
      waitTimer = null;
      waitDuration =
          Duration.zero; // Reset wait duration when stopping the timer
      disposePositionStream();
    });
  }*/

  ///------------------------------ -------------------------------------

  // carSpeed Function Stopped
  // Future<void> stopSpeed() async {
  //   // Set up the position stream listener
  //   Geolocator.getPositionStream().listen((position) {
  //     setState(() {
  //       carSpeed = position.speed;
  //     });
  //   });
  // }

  void stopSpeed() {
    // Check if the car is already stopped
    if (carSpeed <= 1.5) {
      setState(() {
        _getPositionSubscription.cancel();
        carSpeed = 0.0;
      });
      if (kDebugMode) {
        print('Car is already stopped.');
      }
      return;
    }
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
                  cardBar(context, 'Distance',
                      '${coveredDistance.toStringAsFixed(2)} km'),
                ],
              ),
              //Wait Time
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardBar(context, 'Wait Time', '${(seconds)} Seconds'),
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
              // isCalculatingSpeed
              //     ? cardBar(context, 'Total Fare:',
              //         '\$${totalPrice.toStringAsFixed(2)}')
              //     : const Text(''),
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
                  child: isCalculatingSpeed
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isCalculatingSpeed = false;

                              stopTimerOnStopButton();

                              playSound('assets/audio/stop.mp3');

                              calculateFare(
                                baseRate: totalFare,
                                perKilometerRate: ratePerKilometer,
                                distanceCovered: coveredDistance,
                                waitTime: Duration(seconds: seconds),
                              );
                              stopSpeed();

                              _getPositionSubscription.cancel();
                              CustomDialogBox.dialogBox(context, totalPrice);
                              // speak("Your total fare is $totalPrice");
                              coveredDistance = 0.0;
                              previousPosition =
                                  null; // Reset previous position
                              seconds = 0;
                              positionStreamForDistance!.cancel();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            'STOP',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.06,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            toggleTaximeter();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          child: Text(
                            'START',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.06,
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

  void toggleTaximeter() {
    setState(() {
      if (!isCalculatingSpeed) {
        calculateSpeed();
        calculateDistance();
        isCalculatingSpeed = true;
        playSound('assets/audio/start.mp3');
      } /*else {
        isCalculatingSpeed = false;
        playSound('assets/audio/stop.mp3');
        // totalPrice = totalFare * coveredDistance;
        calculateFare(
          distanceCovered: coveredDistance,
          ratePerKilometer: totalFare,
          waitTime: Duration.zero,
        );
        stopSpeed();

        _getPositionSubscription.cancel();
        CustomDialogBox.dialogBox(context, totalPrice);
        coveredDistance = 0.0;
        waitDuration = Duration.zero;

        if (kDebugMode) {
          print("Price:-------->  ${calculateFare(
            distanceCovered: coveredDistance,
            ratePerKilometer: totalFare,
            waitTime: waitDuration,
          )}");
        }
      }*/
    });
  }

  double calculateFare({
    required double baseRate,
    required double perKilometerRate,
    required double distanceCovered,
    required Duration waitTime,
  }) {
    double waitTimeRatePerSecond =
        1 / 60; // 1$ per minute converted to cents per second

    // Calculate fare based on distance
    double distanceFare = baseRate + (perKilometerRate * distanceCovered);

    // Calculate wait time in seconds
    int waitTimeInSeconds = waitTime.inSeconds;

    // Calculate fare based on wait time
    double waitTimeFare = waitTimeRatePerSecond * waitTimeInSeconds;

    // Calculate total fare
    double totalFare = distanceFare + waitTimeFare;

    totalPrice = totalFare;
    return totalPrice;
  }

  /* double calculateFare({
    required double baseRate,
    required double perKilometerRate,
    required double distanceCovered,
    required Duration waitTime,
  }) {
    double waitTimeRatePerMinute = 1;

    // Calculate fare based on distance
    double distanceFare = baseRate + (perKilometerRate * distanceCovered);

    // Calculate wait time in minutes
    int waitTimeInMinutes = waitTime.inMinutes;

    // Calculate fare based on wait time
    double waitTimeFare = waitTimeRatePerMinute * waitTimeInMinutes;

    // Calculate total fare
    double totalFare = distanceFare + waitTimeFare;

    totalPrice = totalFare;
    return totalPrice;
  }*/

  // Future<void> speak(String text) async {
  //   await flutterTts.setLanguage("en-US"); // Change to the desired language
  //   await flutterTts.setPitch(1.0); // Adjust pitch (1.0 is the default)
  //   await flutterTts
  //       .setSpeechRate(0.5); // Adjust speech rate (1.0 is the default)
  //   await flutterTts.speak(text);
  // }

  ///---------------TOTAL FARE ------------------------------

}
