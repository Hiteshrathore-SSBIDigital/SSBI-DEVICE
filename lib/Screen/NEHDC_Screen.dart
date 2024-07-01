import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing/Screen/Setting_Screen.dart';

class Connected_Screen extends StatefulWidget {
  final BluetoothDevice device;
  final BluetoothCharacteristic characteristic;
  final BluetoothService service; // Add this line

  const Connected_Screen({
    Key? key,
    required this.device,
    required this.characteristic,
    required this.service, // Add this line
  }) : super(key: key);

  @override
  _Connected_ScreenState createState() => _Connected_ScreenState();
}

class _Connected_ScreenState extends State<Connected_Screen> {
  bool isConnectedToDevice = false;
  List<String> storedData = [];
  late File dataFile;
  String batteryStatusMessage = 'Battery Level: Unknown';
  String deviceversionmassage = '';

  @override
  void initState() {
    super.initState();
    checkConnectionStatus();
    readBatteryStatus(widget.service);
  }

  Future<void> checkConnectionStatus() async {
    bool connected =
        await widget.device.state.first == BluetoothDeviceState.connected;
    setState(() {
      isConnectedToDevice = connected;
    });
  }

  Future<void> connectToDevice() async {
    try {
      await widget.device.connect();
      setState(() {
        isConnectedToDevice = true;
      });
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  Future<void> disconnectDevice() async {
    try {
      await widget.device.disconnect();
      setState(() {
        isConnectedToDevice = false;
        storedData.clear();
      });
    } catch (e) {
      print('Error disconnecting device: $e');
    }
  }

  Future<void> initializeDataFile() async {
    try {
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        Directory deviceDataDirectory =
            Directory('${directory.path}/DeviceData');
        if (!(await deviceDataDirectory.exists())) {
          await deviceDataDirectory.create();
        }
        String timestamp =
            DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
        dataFile = File('${deviceDataDirectory.path}/$timestamp.txt');
        await dataFile.writeAsString('Some data to store\n',
            mode: FileMode.append, flush: true);
        print('Data file initialized successfully: $timestamp');
      } else {
        print('Error: External storage directory is null');
      }
    } catch (e) {
      print('Error initializing data file: $e');
    }
  }

  void retrieveStoredData(BuildContext context) async {
    bool dataFound = false;
    try {
      BluetoothDevice desiredDevice = widget.device;
      bool isConnected =
          await desiredDevice.state.first == BluetoothDeviceState.connected;
      if (!isConnected) {
        await desiredDevice.connect();
      }
      List<BluetoothService> services = await desiredDevice.discoverServices();
      BluetoothService desiredService = services.firstWhere(
        (service) => service.uuid == widget.characteristic.serviceUuid,
        orElse: () => throw Exception('Service not found'),
      );
      BluetoothCharacteristic desiredCharacteristic =
          desiredService.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == widget.characteristic.uuid,
        orElse: () => throw Exception('Characteristic not found'),
      );
      await desiredCharacteristic.setNotifyValue(true);
      desiredCharacteristic.value.listen((value) {
        setState(() {
          String newData = String.fromCharCodes(value);
          if (newData.trim() == "ÿÿÿÿÿÿ" || newData.startsWith("ÿÿÿÿÿÿ")) {
            // Erase stored data
            //   eraseStoredData(desiredDevice);
          } else {
            if (storedData.isNotEmpty) {
              storedData[storedData.length - 1] += newData;
            } else {
              storedData.add(newData);
            }
            appendDataToFile(newData);
          }
        });
      });
      if (storedData.isNotEmpty) {
        dataFound = true;
      }
    } catch (e) {
      print('Error retrieving data: $e');
    } finally {
      if (!dataFound) {
        // Handle case where data is not found
      } else {
        // Handle case where all data is received
      }
    }
  }

  // Future<void> eraseStoredData(BluetoothDevice device) async {
  //   try {
  //     bool isConnected =
  //         await device.state.first == BluetoothDeviceState.connected;
  //     if (!isConnected) {
  //       await device.connect();
  //     }
  //     List<BluetoothService> services = await device.discoverServices();
  //     BluetoothService desiredService = services.firstWhere(
  //       (service) => service.uuid == widget.characteristic.serviceUuid,
  //       orElse: () => throw Exception('Service not found'),
  //     );
  //     BluetoothCharacteristic desiredCharacteristic =
  //         desiredService.characteristics.firstWhere(
  //       (characteristic) => characteristic.uuid == widget.characteristic.uuid,
  //       orElse: () => throw Exception('Characteristic not found'),
  //     );
  //     await desiredCharacteristic.write([0x01]); // Erase data command
  //     print('Stored data erased successfully.');
  //     await device.disconnect();
  //     print('Device disconnected.');
  //   } catch (e) {
  //     print('Error erasing stored data: $e');
  //   }
  // }

  void appendDataToFile(String newData) async {
    try {
      IOSink sink = dataFile.openWrite(mode: FileMode.append);
      sink.writeln(newData);
      await sink.close();
    } catch (e) {
      print('Error appending data to file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          isConnectedToDevice
              ? 'Connected to: ${widget.device.name}'
              : 'Not Connected',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              isConnectedToDevice ? disconnectDevice() : connectToDevice();
            },
            child: Text(
              isConnectedToDevice ? 'Disconnect' : 'Connect',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Received Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$batteryStatusMessage',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            Expanded(
              child: storedData.isEmpty && isConnectedToDevice
                  ? Center(child: Text('Data Not Found'))
                  : ListView.builder(
                      itemCount: storedData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'Data at index $index: ${storedData[index]}',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              bool isDeviceConnected = await widget.device.state.first ==
                  BluetoothDeviceState.connected;

              if (isDeviceConnected) {
                initializeDataFile();
                retrieveStoredData(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Please connect to the device via Bluetooth.'),
                  ),
                );
              }
            },
            tooltip: 'Get Data',
            child: Icon(Icons.get_app),
          ),
          SizedBox(height: 10),
          if (isConnectedToDevice && storedData.isNotEmpty)
            FloatingActionButton(
              onPressed: () {
                //    eraseStoredData(widget.device);
              },
              tooltip: 'Erase Data',
              child: Icon(Icons.delete),
            ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              // Code to handle interval time
            },
            tooltip: 'Set Interval Time',
            child: Icon(Icons.timer),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              readBatteryStatus(widget.service); // Pass the service
            },
            tooltip: 'Battery Status on Init',
            child: Icon(Icons.battery_alert),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              readDeviceVersion(widget.service);
            },
            tooltip: 'Device Version',
            child: Icon(Icons.update),
          ),
        ],
      ),
    );
  }

// Battery Status
  Future<void> readBatteryStatus(BluetoothService customService) async {
    try {
      if (customService != null) {
        BluetoothCharacteristic customCharacteristic =
            customService.characteristics.firstWhere(
          (characteristic) =>
              characteristic.uuid.toString().toUpperCase() ==
              'F3641402-00B0-4240-BA50-05CA45BF8ABC',
          orElse: () =>
              throw Exception('Custom characteristic with UUID not found'),
        );

        if (customCharacteristic != null) {
          List<int> value = await customCharacteristic.read();
          if (value.isNotEmpty) {
            int batteryLevelHex = value[0];
            int batteryLevelDecimal = (batteryLevelHex & 0xFF);
            setState(() {
              batteryStatusMessage = 'Battery Level: $batteryLevelDecimal%';
            });
          } else {
            print('Battery Level: Unknown');
          }
        } else {
          print('Custom characteristic with UUID not found');
        }
      } else {
        print('Custom service with UUID not found');
      }
    } catch (e) {
      print('Error reading battery status: $e');
    }
  }

// Device Version
  Future<void> readDeviceVersion(BluetoothService customService) async {
    try {
      if (customService != null) {
        BluetoothCharacteristic customCharacteristic =
            customService.characteristics.firstWhere(
          (characteristic) =>
              characteristic.uuid.toString().toUpperCase() ==
              'F3641403-00B0-4240-BA50-05CA45BF8ABC',
          orElse: () =>
              throw Exception('Device version characteristic not found'),
        );

        if (customCharacteristic != null) {
          List<int> value = await customCharacteristic.read();
          if (value.isNotEmpty) {
            String deviceVersionString = String.fromCharCodes(value);
            setState(() {
              deviceversionmassage = 'Device Version: $deviceVersionString';
            });

            // Show AlertDialog
            showMessageDialog(context, deviceversionmassage);
          } else {
            setState(() {
              deviceversionmassage = 'Device Version: Unknown';
            });
          }
        } else {
          setState(() {
            deviceversionmassage = 'Device version characteristic not found';
          });
        }
      } else {
        setState(() {
          deviceversionmassage = 'Custom service with UUID not found';
        });
      }
    } catch (e) {
      setState(() {
        deviceversionmassage = 'Error reading device version: $e';
      });
    }
  }
}
