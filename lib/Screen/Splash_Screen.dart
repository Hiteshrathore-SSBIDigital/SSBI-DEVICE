import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testing/Screen/Device_Screen.dart';
import 'package:testing/Screen/Permission.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    Timer(
      Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Device_Screen(), // Replace HomeScreen with your main screen
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    bool bluetoothPermissionGranted = await requestBluetoothPermission();
    if (!bluetoothPermissionGranted) {
      // Handle the case where Bluetooth permissions are not granted
      // You may want to show a message to the user or guide them on how to grant permissions
      print("Bluetooth permissions not granted");
    }

    bool allPermissionsAccepted = await hasAcceptedPermissions();
    if (!allPermissionsAccepted) {
      // Handle the case where some permissions are not granted
      // You may want to show a message to the user or guide them on how to grant permissions
      print("Some permissions not granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset("assets/Icon/Company.png"),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: Text('Welcome to the main screen!'),
      ),
    );
  }
}
