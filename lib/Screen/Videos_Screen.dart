import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ssbiproject/Setting/Constvariable.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class Video_Screen extends StatefulWidget {
  const Video_Screen({Key? key}) : super(key: key);

  @override
  State<Video_Screen> createState() => _Video_ScreenState();
}

class _Video_ScreenState extends State<Video_Screen> {
  String originalVideoPath = '';
  String compressedVideoPath = '';
  VideoPlayerController? _controller;
  bool isProcessing = false; // Track whether video processing is ongoing

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
            CircularProgressIndicator(), // Show progress bar when processing
          _buildVideo(
            compressedVideoPath.isNotEmpty
                ? VideoPlayerController.file(File(compressedVideoPath))
                : VideoPlayerController.asset('assets/empty_video.mp4'),
            'Compressed Video',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkPermissionsAndSelectVideo(context);
        },
        tooltip: 'Capture Video',
        child: Icon(Icons.videocam),
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
