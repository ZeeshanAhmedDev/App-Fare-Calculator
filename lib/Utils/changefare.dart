import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_meter/Utils/provider.dart';

import 'Button.dart';

class ChangeFareScreen extends StatefulWidget {
  const ChangeFareScreen({super.key});

  @override
  State<ChangeFareScreen> createState() => _ChangeFareScreenState();
}

class _ChangeFareScreenState extends State<ChangeFareScreen> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
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
          ),
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text('Tap back again to leave'),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  //Fare
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        // height: MediaQuery.of(context).size.height * 0.1,
                        child: TextField(
                          controller: textEditingController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          // Allows only numeric and decimal input
                          style: const TextStyle(
                            decorationColor: Color(0xFF7EC349),
                            // color: Colors.black, // Text color
                          ),

                          decoration: const InputDecoration(
                            labelText: 'Change Fare',
                            labelStyle: TextStyle(color: Color(0xFF7EC349)
                                // Cursor color
                                ),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Start or Stop Button
                    MyButton(
                        onPressed: () {
                          Provider.of<UserNotifier>(context, listen: false)
                              .storeFare(
                            double.parse(textEditingController.text),
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Fare saved successfully"),
                          ));
                        },
                        text1: 'Save',
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.9),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
