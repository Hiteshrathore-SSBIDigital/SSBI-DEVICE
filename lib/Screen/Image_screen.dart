import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

import 'package:ssbiproject/Setting/Constvariable.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  String originalImagePath = '';
  String compressedImagePath = '';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Captured Images',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(ColorVal), // Change this to your color
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(8.0),
            children: [
              _buildImage(originalImagePath, 'Original Image'),
              _buildImage(compressedImagePath, 'Compressed Image'),
            ],
          ),
          if (isProcessing)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectImage(context);
        },
        tooltip: 'Capture Image',
        child: Icon(Icons.camera),
      ),
    );
  }

  Widget _buildImage(String imagePath, String title) {
    return imagePath.isNotEmpty
        ? Card(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          )
        : Container();
  }

  Future<void> selectImageFromCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final originalImagePath = image.path;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Image captured!"),
        ),
      );

      await _compressAndSaveImage(originalImagePath);
      setState(() {
        this.originalImagePath = originalImagePath;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No image captured!"),
        ),
      );
    }
  }

  Future<void> _compressAndSaveImage(String originalImagePath) async {
    setState(() {
      isProcessing = true;
    });

    final originalFile = File(originalImagePath);

    try {
      if (!originalFile.existsSync()) {
        throw FileSystemException("File not found");
      }

      final originalBytes = await originalFile.readAsBytes();
      if (originalBytes.isEmpty) {
        throw Exception("Empty file bytes");
      }

      final image = img.decodeImage(originalBytes);
      if (image == null) {
        throw Exception("Failed to decode image");
      }

      final compressedImage = img.encodeJpg(image, quality: 50);
      final compressedFile =
          File(originalFile.path.replaceAll('.jpg', '_compressed.jpg'));
      await compressedFile.writeAsBytes(compressedImage);

      await ImageGallerySaver.saveFile(originalFile.path,
          isReturnPathOfIOS: true);
      await ImageGallerySaver.saveFile(compressedFile.path,
          isReturnPathOfIOS: true);

      setState(() {
        this.compressedImagePath = compressedFile.path;
      });
    } catch (e) {
      print("Error compressing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error compressing image."),
        ),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> selectImage(BuildContext context) async {
    await selectImageFromCamera(context);
  }
}
