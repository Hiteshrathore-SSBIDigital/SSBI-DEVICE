import 'package:flutter/material.dart';
import 'package:testing/Screen/Splash_Screen.dart';

void main() {
  runApp(DeviceTesting());
}

class DeviceTesting extends StatelessWidget {
  const DeviceTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash_Screen(),
    );
  }
}
