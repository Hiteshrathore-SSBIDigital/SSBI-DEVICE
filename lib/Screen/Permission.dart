import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

// Storage Directory
Future<Directory?> getAndroidMediaDirectory() async {
  if (Platform.isAndroid) {
    Directory? storageDirectory =
        await path_provider.getExternalStorageDirectory();
    if (storageDirectory != null) {
      String parentDirectory = storageDirectory.parent.path;
      List<String> parts = parentDirectory.split("/Android/");

      if (parts.length > 1) {
        String directoryPart = parts.first;
        print("Directory Part: $directoryPart");
      } else {
        print("Android directory not found in path");
        return null;
      }

      String androidMediaPath =
          path.join(parts[0], "Android", "media", "SSBI_PROJECT");
      Directory androidMediaDirectory = Directory(androidMediaPath);

      if (!await androidMediaDirectory.exists()) {
        try {
          await androidMediaDirectory.create(recursive: true);
          print(
              'Android Media directory created at: ${androidMediaDirectory.path}');
        } catch (e) {
          print("Error creating Android Media directory: $e");
          return null;
        }
      }
      return androidMediaDirectory;
    }
  }
  return null;
}

Future<bool> requestBluetoothPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
    Permission.location,
  ].request();

  // Check if all Bluetooth permissions are granted
  return statuses[Permission.bluetooth] == PermissionStatus.granted &&
      statuses[Permission.bluetoothScan] == PermissionStatus.granted &&
      statuses[Permission.bluetoothConnect] == PermissionStatus.granted &&
      statuses[Permission.bluetoothAdvertise] == PermissionStatus.granted &&
      statuses[Permission.location] == PermissionStatus.granted;
}

Future<bool> hasAcceptedPermissions() async {
  if (Platform.isAndroid) {
    // Request multiple permissions for Android
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.accessMediaLocation,
      Permission.manageExternalStorage,
      Permission.bluetooth,
    ].request();

    // Check if all permissions are granted
    return statuses[Permission.storage] == PermissionStatus.granted &&
        statuses[Permission.accessMediaLocation] == PermissionStatus.granted &&
        statuses[Permission.manageExternalStorage] ==
            PermissionStatus.granted &&
        statuses[Permission.bluetooth] == PermissionStatus.granted;
  } else if (Platform.isIOS) {
    // Request photos and Bluetooth permission for iOS
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.bluetooth,
    ].request();

    // Check if both permissions are granted
    return statuses[Permission.photos] == PermissionStatus.granted &&
        statuses[Permission.bluetooth] == PermissionStatus.granted;
  } else {
    // Platform other than Android and iOS
    return false;
  }
}
