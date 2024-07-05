// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:ssbiproject/Setting/Constvariable.dart';

// class Bluetooth_Screen extends StatefulWidget {
//   @override
//   _Bluetooth_ScreenState createState() => _Bluetooth_ScreenState();
// }

// class _Bluetooth_ScreenState extends State<Bluetooth_Screen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<BluetoothDevice> devicesList = [];
//   List<bool> connectedStatusList = [];

//   @override
//   void initState() {
//     super.initState();
//     _getPermissionsAndScan();
//   }

//   Future<void> _getPermissionsAndScan() async {
//     // Check and request Bluetooth permissions if needed
//     PermissionStatus status = await Permission.bluetooth.request();
//     if (status != PermissionStatus.granted) {
//       // Handle denied or restricted permissions
//       return;
//     }
//     // Start scanning for nearby Bluetooth devices
//     flutterBlue.scanResults.listen((List<ScanResult> results) {
//       for (ScanResult result in results) {
//         if (!devicesList.contains(result.device)) {
//           setState(() {
//             devicesList.add(result.device);
//             connectedStatusList.add(false); // Initialize as not connected
//           });
//         }
//       }
//     });
//     flutterBlue.startScan();
//   }

//   @override
//   void dispose() {
//     flutterBlue.stopScan();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Bluetooth Device',
//           style: TextStyle(
//               fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Color(ColorVal),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             // Handle back button press here
//             Navigator.of(context).pop();
//           },
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [IconButton(onPressed: () {}, icon: Icon(Icons.scanner))],
//       ),
//       body: ListView.builder(
//         itemCount: devicesList.length,
//         itemBuilder: (context, index) {
//           BluetoothDevice device = devicesList[index];
//           String deviceName =
//               devicesList[index].name.toString() ?? 'Unknown Device';

//           String deviceId = devicesList[index].id.toString() ?? 'No ID';
//           return Column(
//             children: [
//               ListTile(
//                 title: Text(deviceName.toString()),
//                 subtitle: Text(deviceId.toString()),
//                 trailing: connectedStatusList[index]
//                     ? Text('Device is already connected.')
//                     : null,
//                 onTap: () async {
//                   await connectToDevice(devicesList[index], index);
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10, right: 10),
//                 child: Divider(),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Maintain a list to track connected devices
//   List<BluetoothDevice> connectedDevices = [];

//   Future<void> connectToDevice(BluetoothDevice device, int index) async {
//     // Check if the device is already connected before attempting a new connection
//     if (connectedDevices.contains(device)) {
//       print('Connected');
//       setState(() {
//         connectedStatusList[index] = true; // Update connected status
//       });
//       return; // Exit the function, as the device is already connected
//     }

//     // If not connected, proceed to establish a connection
//     try {
//       await device.connect();
//       // Once connected, add the device to the list of connected devices
//       connectedDevices.add(device);

//       // Perform operations on the device
//       readCharacteristic(device, Guid('Your_Characteristic_ID'));
//       // readCharacteristic(device, Guid('0000fffa-0000-1000-8000-00805f9b34fb'));

//       // You can perform other operations as needed
//     } catch (e) {
//       // Handle connection errors
//       print('Connection error: $e');
//     }
//   }

//   void readCharacteristic(BluetoothDevice device, Guid characteristicId) async {
//     try {
//       List<BluetoothService> services = await device.discoverServices();
//       for (BluetoothService service in services) {
//         for (BluetoothCharacteristic characteristic
//             in service.characteristics) {
//           if (characteristic.uuid == characteristicId) {
//             List<int> value = await characteristic.read();
//             print('Read value: $value');
//           }
//         }
//       }
//     } catch (e) {
//       // Handle read characteristic errors
//       print('Read characteristic error: $e');
//     }
//   }

//   // Other Bluetooth interaction methods (writeCharacteristic, subscribeToNotifications)
//   // Follow a similar pattern to handle operations and error handling
// }
