import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ssbiproject/Setting/Splash.dart';

class PermissionRequestScreen extends StatefulWidget {
  @override
  _PermissionRequestScreenState createState() =>
      _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  @override
  void initState() {
    super.initState();
    requestBluetoothPermission();
  }

  Future<void> requestBluetoothPermission() async {
    // Check the Bluetooth service status
    var serviceStatus = await Permission.bluetooth.serviceStatus;

    if (serviceStatus == ServiceStatus.enabled) {
      // Bluetooth service is enabled, check permission status
      var status = await Permission.bluetooth.status;

      if (status == PermissionStatus.granted) {
        // Bluetooth permission granted, navigate to your desired screen (e.g., Splash_Screen)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Splash_Screen()));
      } else {
        // Bluetooth permission denied, request permission
        status = await Permission.bluetooth.request();

        if (status == PermissionStatus.granted) {
          // Bluetooth permission granted, navigate to your desired screen
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Splash_Screen()));
        } else {
          // Bluetooth permission denied, handle accordingly
          // You can show an error message or take appropriate action
        }
      }
    } else {
      // Bluetooth service is not enabled, handle accordingly
      // You can prompt the user to enable Bluetooth or take appropriate action
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Request Example'),
      ),
      body: Center(
        child: Text('Checking Bluetooth Service and Requesting Permission...'),
      ),
    );
  }
}
