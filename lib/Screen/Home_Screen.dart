import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssbiproject/Login_Screen/DemoScreen.dart';
import 'package:ssbiproject/Login_Screen/Witmotion.dart';
import 'package:ssbiproject/Other_screen/CheckApi.dart';
import 'package:ssbiproject/Other_screen/Notification.dart';
import 'package:ssbiproject/Screen/Bottom_Screen.dart';
import 'package:ssbiproject/Screen/Image_screen.dart';
import 'package:ssbiproject/Screen/Location.dart';
import 'package:ssbiproject/Screen/QRScan_Screen.dart';
import 'package:ssbiproject/Screen/Videos_Screen.dart';
import 'package:ssbiproject/Setting/Constvariable.dart';

class NewHome_Screen extends StatelessWidget {
  final String usersrole;
  NewHome_Screen({required this.usersrole});
  // Define supported locales for your app
  final List<Map<String, dynamic>> locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
    {'name': 'অসমীয়া', 'locale': Locale('as', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back(); // Close the language dialog
    Get.updateLocale(locale);
    print("Updated Locale: $locale");
  }

  // Function to build and show the language selection dialog
  buildLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text(
            'Choose Your Language',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text(locale[index]['name']),
                    onTap: () {
                      print(locale[index]['name']);
                      updateLanguage(locale[index]['locale']);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.blue,
                );
              },
              itemCount: locale.length,
            ),
          ),
        );
      },
    );
  }

// Logout
  Future<void> showLogoutAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                exit(0);
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current locale of the app
    Locale? _currentLocale = Get.locale;

    // Scaffold is the basic structure for a screen in Flutter
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets\Icon\logov1.png'),
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(City)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      child: Container(
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Color(0xff800000),
                          child: Text(
                            "X",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("User: $json"),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Divider(),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Color(ColorVal),
                      ),
                      title: Text("Home"),
                      trailing: Icon(Icons.keyboard_arrow_right_outlined),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Bottom_Screen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Color(ColorVal),
                        ),
                      ),
                      // QR scan
                      title: Text("hello".tr),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => QRScan_Screen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.image,
                          color: Color(ColorVal),
                        ),
                      ),
                      // Image
                      title: Text("message".tr),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ImageScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.video_collection_outlined,
                          color: Color(ColorVal),
                        ),
                      ),
                      //Videos
                      title: Text("title".tr),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Video_Screen(),
                          ),
                        );
                      },
                    ),
                    // location
                    ListTile(
                        leading: Container(
                          child: Icon(
                            Icons.location_on,
                            color: Color(ColorVal),
                          ),
                        ),
                        title: Text("sub".tr),
                        trailing: Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: Color(ColorVal),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Locationss(),
                            ),
                          );
                        }),
                    // blutooth
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.bluetooth,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text("changelang".tr),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         Bluetooth_Screen(),
                        //   ),
                        // );
                      },
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.language,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text("Language".tr),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        buildLanguageDialog(context);
                      },
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.login,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text("Log out"),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        showLogoutAlertDialog(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color to your desired color
        ),
        backgroundColor: Color(ColorVal),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.language),
            color: Colors.white,
            onPressed: () {
              buildLanguageDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Notification_screen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(ColorVal)),
                ),
                Text(
                  "View All",
                  style: TextStyle(
                      color: Color(ColorVal), fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.qr_code_scanner_rounded,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      QRScan_Screen()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("hello".tr),
                    ],
                  ),
                  // SizedBox(width: 20),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ImageScreen()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("message".tr),
                    ],
                  ),
                  //   SizedBox(width: 20),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.video_collection,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Video_Screen()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("title".tr),
                    ],
                  ),
                  //  SizedBox(width: 20),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Locationss()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("sub".tr),
                    ],
                  ),
                  //    SizedBox(width: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.bluetooth,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BluetoothScreen(
                                        title: '',
                                      )));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("changelang".tr),
                    ],
                  ),
                  // SizedBox(width: 20),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ApiScreen()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("APIs".tr),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Demo_Screen()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Add Product".tr),
                    ],
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
