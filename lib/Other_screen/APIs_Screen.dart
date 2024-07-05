import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:ssbiproject/Other_screen/Static_varible.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Temp {
  final String tempurl;

  Temp({required this.tempurl});
}

class TempAPIs {
  final String apiUrl = staticverible.temqr + "qrhandloom/QRcheck.aspx/GetData";

  Future<List<Temp>> fetchTemp(String qrvalue) async {
    try {
      final Map<String, dynamic> requestBody = {"qrvalue": qrvalue};
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        // Check if 'd' is a string
        if (responseData['d'] is String) {
          // Parse the 'd' string as JSON
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);

          // Check if 'message' is a string
          if (dataMap['message'] is String) {
            String stringValue = dataMap['message'];
            // Do something with stringValue, or return a single Temp object if that's what you need
            return [Temp(tempurl: stringValue)];
          } else if (dataMap['message'] is List<dynamic>) {
            // Proceed with the existing logic for handling a list
            final List<dynamic> data = dataMap['message'];

            return data
                .map((item) => Temp(
                      tempurl: item['message'].toString(),
                    ))
                .toList();
          } else {
            // Handle other cases if needed
            throw Exception('Unexpected data format for "message"');
          }
        } else {
          // Handle other cases if needed
          throw Exception('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load Qr Scan');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load Qr Scan: $e');
    }
  }
}

class Login {
  final String username;
  final String password;

  Login({required this.username, required this.password});
}

class LogAPIs {
  final String loginUrl = "http://192.168.1.52/handloom/login.aspx/CheckLogin";

  Future<List<Login>> loginUser(String username, String password) async {
    try {
      final Map<String, dynamic> requestBody = {
        "username": username,
        "password": password
      };
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData != null && responseData['d'] != null) {
          final dynamic data = responseData['d'];

          if (data is String) {
            final Map<String, dynamic> dataMap = json.decode(data);

            if (dataMap.containsKey('statuscode')) {
              String statuscode = dataMap['statuscode'].toString();

              if (statuscode == '1') {
                if (dataMap.containsKey('userid') &&
                    dataMap.containsKey('role')) {
                  String userid = dataMap['userid'].toString();
                  String role = dataMap['role'].toString();

                  return [Login(username: userid, password: role)];
                } else {
                  // Log the response body for further investigation
                  print('Response Body: ${response.body}');
                  // Handle the case where 'userid' or 'role' is missing
                  throw Exception(
                      'Invalid or missing "userid" or "role" in response');
                }
              } else if (statuscode == '2') {
                throw Exception('Invalid UserId or Password');
              } else if (statuscode == '3') {
                throw Exception('Other status code: $statuscode');
              } else {
                throw Exception('Unexpected status code');
              }
            } else {
              // Log the response body for further investigation
              print('Response Body: ${response.body}');
              throw Exception('Missing "statuscode" in response');
            }
          } else {
            throw Exception('Unexpected type for "d" in response');
          }
        } else {
          throw Exception('Response data or "d" is null');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load Login');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to load Login: $e');
    }
  }
}

// Database
class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'MST_URL';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  static Future<Database> initializeDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'sbbi.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          url TEXT
        )
      ''');
    });
  }

  static Future<int> insertUrl({required String url}) async {
    final Database db = await database;

    return await db.insert(tableName, {'url': url});
  }

  static Future<int> updateUrl({required int id, required String url}) async {
    final Database db = await database;

    return await db.update(
      tableName,
      {'url': url},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAll() async {
    final Database db = await database;
    await db.delete(tableName);
  }

  static Future<List<Map<String, dynamic>>?> getUrls() async {
    final Database db = await database;
    List<Map<String, dynamic>>? urls;

    try {
      urls = await db.query(tableName);
    } catch (e) {
      print('Error retrieving data: $e');
    }

    return urls;
  }
}
