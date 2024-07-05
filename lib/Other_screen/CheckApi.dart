import 'package:flutter/material.dart';
import 'package:ssbiproject/Other_screen/APIs_Screen.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  final TempAPIs apitemp = TempAPIs();
  late Future<List<Temp>> items;

  @override
  void initState() {
    super.initState();
    items = apitemp.fetchTemp('57D35CDDA8CE4E33');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APIs Testing',
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
        backgroundColor: Color(0xff022a72),
      ),
      body: FutureBuilder<List<Temp>>(
        future: items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display the list of Temp items in your widget
            List<Temp> tempItems = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tempItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tempItems[index].tempurl),
                );
              },
            );
          }
        },
      ),
    );
  }
}
