import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ssbiproject/Setting/Constvariable.dart';

class Locationss extends StatefulWidget {
  @override
  _LocationssState createState() => _LocationssState();
}

class _LocationssState extends State<Locationss> {
  loc.Location location = loc.Location();
  loc.LocationData? currentLocation;
  String deviceName = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getDeviceName();
  }

  Future<void> _getLocation() async {
    ph.PermissionStatus permissionStatus =
        await ph.Permission.location.request();

    if (permissionStatus == ph.PermissionStatus.granted) {
      try {
        currentLocation = await location.getLocation();
        setState(() {});
      } catch (e) {
        print('Failed to get location: $e');
      }
    } else {
      print('Location permission denied');
    }
  }

  Future<void> _getDeviceName() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceName = androidInfo.model;
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceName = iosInfo.model;
        });
      }
    } catch (e) {
      print('Failed to get device name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Location',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle back button press here
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color(ColorVal),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Device Name: $deviceName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (currentLocation != null)
              Text(
                'Latitude: ${currentLocation!.latitude}, Longitude: ${currentLocation!.longitude}',
                style: TextStyle(fontSize: 18),
              )
            else
              Text(
                'Location not available',
                style: TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
