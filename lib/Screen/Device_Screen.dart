import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:testing/Screen/NEHDC_Screen.dart';
import 'package:testing/Screen/Setting_Screen.dart';

class Device_Screen extends StatefulWidget {
  const Device_Screen({Key? key}) : super(key: key);

  @override
  State<Device_Screen> createState() => _Device_ScreenState();
}

class _Device_ScreenState extends State<Device_Screen> {
  List<ScanResult> devices = [];
  bool isScanning = false;
  bool isBluetoothOn = true; // Track Bluetooth state

  @override
  void initState() {
    super.initState();
    _initBluetooth(context);
  }

  Future<void> _initBluetooth(BuildContext context) async {
    FlutterBlue flutterBlue = FlutterBlue.instance;

    // Listen to Bluetooth state changes
    flutterBlue.state.listen((BluetoothState state) {
      setState(() {
        isBluetoothOn = state == BluetoothState.on;
        if (isBluetoothOn) {
          // Bluetooth is on, start scanning
          startScan();
        } else {
          // Bluetooth is off, display alert
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Bluetooth Scanner",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  "Turn on Bluetooth to scan nearby devices.",
                  style: TextStyle(fontSize: 13),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Device Scan',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: isScanning ? stopScan : startScan,
            child: Text(
              isScanning ? 'STOP SCANNING' : 'SCAN',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(ColorVal), // Use your color
      ),
      body: Column(
        children: [
          if (!isBluetoothOn) // Show red container if Bluetooth is off
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bluetooth is disabled",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        _enableBluetooth(context);
                      },
                      child: Text(
                        "Enable",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                // Check if the device advertises the desired service UUID
                bool hasDesiredService = devices[index]
                    .advertisementData
                    .serviceUuids
                    .contains('f3641400-00b0-4240-ba50-05ca45bf8abc');

                if (!hasDesiredService) {
                  // Skip this device if it doesn't advertise the desired service UUID
                  return SizedBox.shrink();
                }
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.bluetooth,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.cyan,
                  ),
                  title: Text(
                    devices[index].device.name ?? 'NA',
                    style: TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(
                    devices[index].device.id.toString(),
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: InkWell(
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width / 7.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue, // Use your color
                      ),
                      child: Center(
                        child: Text(
                          "Connect",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      connectToDevice(context, devices[index].device);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void startScan() {
    setState(() {
      devices.clear();
      isScanning = true;
    });

    FlutterBlue.instance.scanResults.listen((List<ScanResult> scanResults) {
      setState(() {
        devices = scanResults;
      });
    });

    FlutterBlue.instance.startScan();
  }

  void stopScan() {
    setState(() {
      isScanning = false;
    });
    FlutterBlue.instance.stopScan();
  }

  void connectToDevice(BuildContext context, BluetoothDevice device) async {
    try {
      await device.connect();
      print('Connected to ${device.name}');

      // Add a short delay before service discovery
      await Future.delayed(Duration(seconds: 1));

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      print('Discovered Services: ${services.map((s) => s.uuid).toList()}');

      // Find the custom service with the specified UUID
      BluetoothService customService = services.firstWhere(
        (service) =>
            service.uuid.toString() == 'f3641400-00b0-4240-ba50-05ca45bf8abc',
        orElse: () => throw Exception('Custom service with UUID not found'),
      );

      if (customService != null) {
        // Find the characteristic within the custom service
        BluetoothCharacteristic customCharacteristic =
            customService.characteristics.firstWhere(
          (characteristic) =>
              characteristic.uuid.toString() == 'f3641401-00b0-4240-ba50-05ca45bf8abc' ||
              characteristic.uuid.toString() ==
                  'f3641402-00b0-4240-ba50-05ca45bf8abc' ||
              characteristic.uuid.toString() ==
                  'f3641403-00b0-4240-ba50-05ca45bf8abc',
          orElse: () =>
              throw Exception('Custom characteristic with UUID not found'),
        );

        if (customCharacteristic != null) {
          // Navigate to the connected screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Connected_Screen(
                device: device,
                characteristic: customCharacteristic,
                service: customService, // Pass the customService here
              ),
            ),
          );
        } else {
          print('Custom characteristic with UUID not found');
          // Handle case where custom characteristic is not found
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Custom characteristic not found in the service.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        print('Custom service with UUID not found');
        // Handle case where custom service is not found
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Custom service not found on the device.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error connecting to ${device.name}: $e');
      // Handle connection error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect to the device. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _enableBluetooth(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "An app wants to turn on Bluetooth.",
            style: TextStyle(fontSize: 12),
          ),
          actionsPadding: EdgeInsets.symmetric(
              horizontal: 10.0), // Adjust padding as needed
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    FlutterBlue flutterBlue = FlutterBlue.instance;
                    //   flutterBlue.openSettings();
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
