import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ssbiproject/Screen/QRScan_Screen.dart';
import 'package:ssbiproject/Setting/Constvariable.dart';
import 'package:image/image.dart' as img;
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class Demo_Screen extends StatefulWidget {
  const Demo_Screen({super.key});

  @override
  State<Demo_Screen> createState() => _Demo_ScreenState();
}

class _Demo_ScreenState extends State<Demo_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: QRScan_Screen(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(children: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Temp_Product()),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "Next",
                        style: TextStyle(
                            color: Color(ColorVal),
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.arrow_forward),
                      )
                    ],
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}

//
class Temp_Product extends StatefulWidget {
  const Temp_Product({super.key});

  @override
  State<Temp_Product> createState() => _Temp_ProductState();
}

class _Temp_ProductState extends State<Temp_Product> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Detailas',
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(ColorVal),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Weaver Name"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Product Name"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Organization Name"),
                )
              ],
            ),
          )
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Temp_Image()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(
                              color: Color(ColorVal),
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_forward),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Image
class Temp_Image extends StatefulWidget {
  const Temp_Image({super.key});

  @override
  State<Temp_Image> createState() => _Temp_ImageState();
}

class _Temp_ImageState extends State<Temp_Image> {
  String originalImagePath = '';
  String compressedImagePath = '';

  void initState() {
    super.initState();
    // Call the method to open the camera when the screen loads
    selectImageFromCamera(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Captured Images',
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(ColorVal),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          _buildImage(originalImagePath, 'Original Image'),
          _buildImage(compressedImagePath, 'Compressed Image'),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Temp_Videos()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(
                              color: Color(ColorVal),
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_forward),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Path set Image Screen
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

// Camera Using Image Click
  Future<void> selectImageFromCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final originalImagePath = image.path;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Image captured and saved!"),
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

//Orignal or Compress Image Save in Gallery
  Future<void> _compressAndSaveImage(String originalImagePath) async {
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
    }
  }

// Select Image For Camera
  Future<void> selectImage(BuildContext context) async {
    await selectImageFromCamera(context);
  }
}

// videos screen Starts
class Temp_Videos extends StatefulWidget {
  const Temp_Videos({super.key});

  @override
  State<Temp_Videos> createState() => _Temp_VideosState();
}

class _Temp_VideosState extends State<Temp_Videos> {
  String originalVideoPath = '';
  String compressedVideoPath = '';
  VideoPlayerController? _controller;
  bool isProcessing = false; // Track whether video processing is ongoing

  void initState() {
    super.initState();
    checkPermissionsAndSelectVideo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Captured Videos',
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
        backgroundColor: Color(ColorVal),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          if (_controller != null) _buildVideo(_controller!, 'Original Video'),
          _buildVideoPlayer(),
          if (isProcessing)
            LinearProgressIndicator(), // Show progress bar when processing
          _buildVideo(
            compressedVideoPath.isNotEmpty
                ? VideoPlayerController.file(File(compressedVideoPath))
                : VideoPlayerController.asset('assets/empty_video.mp4'),
            'Compressed Video',
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Temp_Videos()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Finish",
                          style: TextStyle(
                              color: Color(ColorVal),
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_forward),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideo(VideoPlayerController controller, String title) {
    return Card(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return _controller != null && _controller!.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          )
        : Container();
  }

  Future<void> checkPermissionsAndSelectVideo(BuildContext context) async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      selectVideo(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permission denied for accessing camera.'),
        ),
      );
    }
  }

  Future<void> selectVideo(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedVideo = await _picker.pickVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 30));

    if (pickedVideo != null) {
      final String videoPath = pickedVideo.path;

      try {
        setState(() {
          isProcessing =
              true; // Set processing to true when video selection starts
        });

        final MediaInfo? compressedVideoInfo =
            await VideoCompress.compressVideo(
          videoPath,
          quality: VideoQuality.DefaultQuality,
          deleteOrigin: false,
        );

        if (compressedVideoInfo != null) {
          final String originalVideoPath = videoPath;
          final String compressedVideoPath =
              compressedVideoInfo.path ?? originalVideoPath;

          setState(() {
            this.originalVideoPath = originalVideoPath;
            this.compressedVideoPath = compressedVideoPath;
            _controller = VideoPlayerController.file(File(originalVideoPath))
              ..initialize().then((_) {
                setState(() {});
                _controller!.play();
              });
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Video captured and compressed!"),
            ),
          );

          await GallerySaver.saveVideo(compressedVideoPath);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Video saved to gallery!"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to compress video!"),
            ),
          );
        }
      } catch (e) {
        print("Error compressing video: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error compressing video!"),
          ),
        );
      } finally {
        setState(() {
          isProcessing =
              false; // Set processing to false when video processing is done
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No video captured!"),
        ),
      );
    }
  }
}
