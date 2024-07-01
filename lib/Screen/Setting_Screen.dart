import 'dart:async';
import 'package:flutter/material.dart';

String version = 'Version 0.0.46';
String name = 'SSBI Digital PVT.LTD.';
String City = 'Ahmedabad';
final int ColorVal = 0xff022a72;
final String mycolor = '#${ColorVal.toRadixString(16)}';

// Please Wait Method
void plaesewaitmassage(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            // Specify a custom shape
            borderRadius: BorderRadius.zero, // Set border radius to zero
          ),
          title: Text(
            "Please Wait",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          content: Container(
            child: Row(
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text("Loading.."),
                )
              ],
            ),
          ));
    },
  );
}

void _showDialog(BuildContext context, dynamic message, IconData? iconData,
    Color iconColor, Color messageColor) {
  if (message is List<String>) {
    message = message.join('\n');
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: iconData != null
            ? Icon(iconData, color: iconColor, size: 60.0)
            : null,
        content: Text(
          message,
          style: TextStyle(color: messageColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
        backgroundColor: Colors.white,
      );
    },
  );
}

Future<void> showMessageDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Message'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
