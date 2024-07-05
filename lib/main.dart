import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssbiproject/Other_screen/Permission_Screen.dart';
import 'package:ssbiproject/Setting/LocaleString.dart';
import 'package:flutter/services.dart';

void main() {
  Get.put<Locale>(Locale('en', 'US'));
  runApp(Company());
}

class Company extends StatefulWidget {
  const Company({Key? key}) : super(key: key);

  @override
  State<Company> createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: Locale('en', 'US'),
      theme: ThemeData(
        backgroundColor: Color(0xff022a72),
        primarySwatch: Colors.blue,
      ),
      home:
          PermissionRequestScreen(), // Navigate to PermissionRequestScreen first
    );
  }
}
