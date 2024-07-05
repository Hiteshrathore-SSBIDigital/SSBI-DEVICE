import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ssbiproject/Login_Screen/DemoData.dart';
import 'package:ssbiproject/Setting/Constvariable.dart';
import 'dart:async';

class BluetoothScreen extends StatefulWidget {
  BluetoothScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;
  bool _isConnected = false;
  String receivedData = '';
  StreamSubscription<List<ScanResult>> _scanSubscription =
      StreamController<List<ScanResult>>().stream.listen((_) {});
  @override
  initState() {
    super.initState();
    initBle();
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      if (mounted) {
        // Check if the widget is still mounted
        _isScanning = isScanning;
        setState(() {});
      }
    });
  }

  Future<void> scan() async {
    if (mounted) {
      if (!_isScanning) {
        scanResultList.clear();
        flutterBlue.startScan(timeout: Duration(seconds: 4));
        // Store the subscription to cancel it in dispose
        _scanSubscription = flutterBlue.scanResults.listen((results) {
          if (mounted) {
            setState(() {
              // Update your state here based on the scanning result
              scanResultList = results;
            });
          }
        });
      } else {
        flutterBlue.stopScan();
      }
    }
  }

  // Inside _BluetoothScreenState class

  void onTap(ScanResult r) async {
    // Generate a device ID from the device name
    String deviceId = generateDeviceId(r.device.name);

    // Check if already connected
    if (_isConnected) {
      // Show a snackbar indicating the device is already connected
      final snackBar = SnackBar(
        content: Text("$deviceId is already connected."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Show a snackbar indicating the connection process
    final snackBar = SnackBar(
      content: Text("Connecting to $deviceId..."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    try {
      // Connect to the selected device
      await r.device.connect();

      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _isConnected = true;
        });
      }

      // Show a dialog for pairing request
      bool pairSuccess = await showPairingDialog();

      if (pairSuccess) {
        // Perform actions after successful pairing
        print('Device $deviceId paired successfully!');

        // Store or display data here, you can use a separate method for this
        await processData(r.device);
        // Navigate to DataDisplayScreen with the received data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DataDisplayScreen(receivedData: receivedData),
          ),
        );
        // ... Perform other actions like sending data, etc.
      } else {
        // Handle pairing failure
        print('Failed to pair with device $deviceId');
        // Disconnect from the device if pairing failed
        await r.device.disconnect();
      }
    } catch (error) {
      print('Error connecting to device $deviceId: $error');
      // Update the connection status on error
      setState(() {
        _isConnected = false;
      });
    } finally {
      // Hide the snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  Future<void> processData(BluetoothDevice device) async {
    try {
      // Establish Bluetooth connection
      await device.connect();

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      // Find the target service
      BluetoothService? targetService = services.firstWhere(
        (BluetoothService? service) =>
            service?.uuid == Guid('0000ffe4-0000-1000-8000-00805f9a34fb'),
        orElse: null,
      );

      if (targetService != null) {
        // Find the target characteristic
        BluetoothCharacteristic? targetCharacteristic =
            targetService.characteristics.firstWhere(
          (BluetoothCharacteristic characteristic) =>
              characteristic.uuid ==
              Guid('0000ffe4-0000-1000-8000-00805f9a34fb'),
          orElse: null,
        );

        if (targetCharacteristic != null) {
          // Read from the characteristic
          List<int> value = await targetCharacteristic.read();

          // Check if the data is not empty
          if (value.isNotEmpty) {
            // Process the read value and store it
            receivedData = utf8.decode(value);

            // Update UI if necessary (make sure to use setState if on Flutter)
            setState(() {
              // Update UI here
            });
          } else {
            print('Read operation successful, but data is empty.');
          }
        } else {
          print('Characteristic not found in the service.');
        }
      } else {
        print('Service not found on the device.');
      }
    } catch (e) {
      print('Error during Bluetooth operations: $e');
      // Handle the error as needed
    } finally {
      // Disconnect from the device
      await device.disconnect();
    }
  }

  Future<bool> showPairingDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pairing Confirmation"),
          content: Text("Do you want to pair with this device?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Pair"),
            ),
          ],
        );
      },
    );
  }

  String generateDeviceId(String deviceName) {
    return 'ID_${deviceName.replaceAll(' ', '_')}';
  }

  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          deviceSignal(r),
          if (isWitMotionDevice(r)) Text('WitMotion Device'),
        ],
      ),
    );
  }

  bool isWitMotionDevice(ScanResult r) {
    // Check if the device has a specific service UUID that indicates it is a WitMotion device
    List<String> serviceUuids = r.advertisementData.serviceUuids ?? [];
    bool hasWitMotionService = serviceUuids.any((uuid) =>
        uuid.toLowerCase() ==
        '0000ffe0-0000-1000-8000-00805f9b34fb'); // Replace with the actual WitMotion service UUID

    return hasWitMotionService;
  }

  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      name = r.advertisementData.localName;
    } else {
      name = 'Unknown Device';
    }
    return Text(name);
  }

  Widget leading(ScanResult r) {
    return CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bluetooth Testing",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(ColorVal),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              _isConnected ? 'Connected - Data: $receivedData' : 'Disconnected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: scanResultList.length,
                itemBuilder: (context, index) {
                  return listItem(scanResultList[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: Icon(_isScanning ? Icons.stop : Icons.bluetooth),
      ),
    );
  }
}
