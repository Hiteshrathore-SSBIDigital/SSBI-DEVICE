// DataDisplayScreen.dart

import 'package:flutter/material.dart';

class DataDisplayScreen extends StatelessWidget {
  final String receivedData;

  DataDisplayScreen({required this.receivedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Display Screen'),
      ),
      body: Center(
        child: Text(
          'Received Data: $receivedData',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
