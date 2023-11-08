import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_meter/Utils/provider.dart';

class CustomDialogBox {
  static final TextEditingController textEditingController =
      TextEditingController();

  static String value = "";

  static dialogBox(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      title: 'Dialog Title',
      // desc: 'Dialog description here.............',
      body: TextField(
        controller: textEditingController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
      btnOkOnPress: () async {
        Provider.of<UserNotifier>(context, listen: false)
            .storeFare(textEditingController.text);
      },
    ).show();
  }
}
