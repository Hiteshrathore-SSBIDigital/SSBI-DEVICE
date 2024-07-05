import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ssbiproject/Other_screen/APIs_Screen.dart';
import 'dart:ui' as ui;

import 'package:ssbiproject/Setting/Constvariable.dart';

class QRScan_Screen extends StatefulWidget {
  const QRScan_Screen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScan_ScreenState();
}

class _QRScan_ScreenState extends State<QRScan_Screen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final TempAPIs apiservice = TempAPIs();
  late Future<List<Temp>> item;
  String qrval = '';
  String responseMessage = '';

  late List<Temp> tempData; // Declare tempData at the class level

  @override
  void initState() {
    super.initState();
    fetchData(); // Call fetchData in initState to initiate the API call
  }

  void fetchData() async {
    try {
      List<Temp> tempData = await apiservice.fetchTemp(qrval);

      // Assuming you want to display the data in a simple way, you can print it
      for (Temp temp in tempData) {
        print('Temp URL: ${temp.tempurl}');
      }

      // Assuming the response message is the first tempurl, you can update the state
      if (tempData.isNotEmpty) {
        setState(() {
          responseMessage = '${tempData[0].tempurl}';
        });
      } else {
        // Handle the case where tempData is empty
        setState(() {
          responseMessage = '';
        });
      }
    } catch (e) {
      // Handle errors here
      print('Error fetching data: $e');
      setState(() {
        responseMessage = 'Error: $e';
      });
    }
  }

// used qrcode massage
  void AlertMassage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            height: 50,
            child: Column(
              children: [
                Text(
                  "This QR code has already been used. Please scan a new QR code.!",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                // You can add additional content or widgets here
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 16, color: Color(ColorVal)),
              ),
            ),
          ],
        );
      },
    );
  }

// Invaild qr massage
  void InvaildQrMass(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            height: 50,
            child: Column(
              children: [
                Text(
                  "Invaild QR code Please vaild QR code scan !",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                // You can add additional content or widgets here
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 16, color: Color(ColorVal)),
              ),
            ),
          ],
        );
      },
    );
  }

//
  void NetworkIssueMass(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            height: 50,
            child: Column(
              children: [
                Text(
                  "Oops! You don't seem to be connected to the internet Please connect & try again.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                // You can add additional content or widgets here
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 16, color: Color(ColorVal)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Scan",
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
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  //   Text(responseMessage), QR Massage Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('Pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('Resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (result != null && result!.code != null && result!.code!.isNotEmpty) {
        String qrValue = result!.code!;
        try {
          List<Temp> tempData = await apiservice.fetchTemp(qrValue);
          for (Temp temp in tempData) {
            print('Temp URL: ${temp.tempurl}');
          }

          // Display the printed value in the UI
          if (tempData.isNotEmpty) {
            setState(() {
              responseMessage = '${tempData[0].tempurl}';
              if (responseMessage == 'QR code is Already Used.') {
                AlertMassage(context);
              } else if (responseMessage
                  .startsWith('No data found for qrvalue:')) {
                InvaildQrMass(context);
              } else if (responseMessage.startsWith('Failed host lookup:')) {
                NetworkIssueMass(context);
              } else {
                _saveImageToGallery(controller);
              }
            });
          } else {
            // Handle the case where tempData is empty
            setState(() {
              responseMessage = '';
            });
          }
        } catch (e) {
          print('Error calling API: $e');
          // Handle errors here
          setState(() {
            responseMessage = 'Error: $e';
          });
        }
      }
    });
  }

  Future<void> _saveImageToGallery(QRViewController controller) async {
    Completer<void> completer = Completer<void>();

    try {
      GlobalKey repaintKey = GlobalKey();

      // Wrap QRView with RepaintBoundary
      Widget qrViewWithRepaint = RepaintBoundary(
        key: repaintKey,
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          // ... other properties ...
        ),
      );

      // Wait until the widget tree is fully built
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // Check if repaintKey.currentContext is not null before proceeding
        if (repaintKey.currentContext != null) {
          RenderRepaintBoundary boundary = repaintKey.currentContext!
              .findRenderObject() as RenderRepaintBoundary;

          // Check if boundary.toImage returns a non-null value
          ui.Image? image = await boundary.toImage(pixelRatio: 3.0);

          if (image != null) {
            ByteData? byteData =
                await image.toByteData(format: ui.ImageByteFormat.rawRgba);

            if (byteData != null) {
              Uint8List byteList = byteData.buffer.asUint8List();

              // Save the image to a temporary file
              File tempFile =
                  await File('path/to/temp_image.png').writeAsBytes(byteList);

              // Save the temporary file to the gallery
              final result = await ImageGallerySaver.saveFile(tempFile.path);

              print('Image saved to gallery: $result');
              completer
                  .complete(); // Complete the Future when everything is done
            } else {
              completer.completeError('ByteData is null');
            }
          } else {
            completer.completeError('Image is null');
          }
        } else {
          completer.completeError('Repaint key current context is null');
        }
      });
    } catch (e) {
      print('Error saving image to gallery: $e');
      completer.completeError(e); // Complete with an error if there's an issue
    }

    // Remove the line below, as Completer<void> doesn't return a value
    // await completer.future; // Wait for the completion of the entire process
  }

  void _exitApp(List<Temp> tempData) {
    print('Exiting the app after scanning and handling data.');
    exit(0);
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
