import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart' as cam;
import 'package:kkh_events/screens/EditVideoScreen.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;
import 'package:path_provider/path_provider.dart';
// import 'edit_video_screen.dart'; // Import the new screen

class ReelCameraScreen extends StatefulWidget {
  final int userId;
  const ReelCameraScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ReelCameraScreenState createState() => _ReelCameraScreenState();
}

class _ReelCameraScreenState extends State<ReelCameraScreen> {
  cam.CameraController? _cameraController;
  List<cam.CameraDescription>? cameras;
  final ImagePicker _picker = ImagePicker();
  File? _selectedVideo;
  File? _thumbnail;
  bool isRearCamera = true;
  bool isRecording = false;
  Timer? _timer;
  int _recordingTimeInSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  // Initialize the camera
  Future<void> _initCamera() async {
    cameras = await cam.availableCameras();
    _cameraController = cam.CameraController(
        cameras![0], cam.ResolutionPreset.high); // Rear camera
    await _cameraController!.initialize();
    setState(() {});
  }

  // Switch between rear and front cameras
  void _switchCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
      isRearCamera = !isRearCamera;
      _cameraController = cam.CameraController(
        cameras![isRearCamera ? 0 : 1],
        cam.ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  // Start a timer to track recording duration
  void _startRecordingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingTimeInSeconds++;
      });
    });
  }

  // Stop the recording timer
  void _stopRecordingTimer() {
    _timer?.cancel();
    _recordingTimeInSeconds = 0;
  }

  // Record a video using the camera
  Future<void> _recordVideo() async {
    if (isRecording) {
      final videoFile = await _cameraController!.stopVideoRecording();
      _stopRecordingTimer();
      setState(() {
        isRecording = false;
      });
      // Navigate to the edit screen after recording completes
      _navigateToEditScreen(File(videoFile.path));
    } else {
      await _cameraController!.startVideoRecording();
      _startRecordingTimer();
      setState(() {
        isRecording = true;
      });
    }
  }

  // Open gallery to pick a video
  Future<void> _pickVideoFromGallery() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // Navigate to the edit screen after video is picked
      _navigateToEditScreen(File(video.path));
    }
  }

  // Navigate to the next screen to edit video (with thumbnail)
  void _navigateToEditScreen(File videoFile) async {
    // Generate thumbnail
    final thumbnailPath = await thumbnail.VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: thumbnail.ImageFormat.PNG,
      maxHeight: 100,
      quality: 75,
    );

    if (thumbnailPath != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditVideoScreen(
          userId: widget.userId,
          videoFile: videoFile,
          defaultThumbnail: File(thumbnailPath),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          _cameraController != null && _cameraController!.value.isInitialized
              ? ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20), // iOS-like rounded corners
                  child: cam.CameraPreview(_cameraController!),
                )
              : const Center(child: CircularProgressIndicator()),

          // Recording Time Display
          if (isRecording)
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _formatRecordingTime(_recordingTimeInSeconds),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Bottom buttons overlay (Thumbnail)
          Positioned(
            bottom: 30,
            left: 20,
            child: _thumbnail != null
                ? GestureDetector(
                    onTap: _pickVideoFromGallery,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(_thumbnail!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: _pickVideoFromGallery,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.video_library,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
          ),

          // Center recording button
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: GestureDetector(
              onTap: _recordVideo,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isRecording ? Colors.grey : Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRecording ? Icons.stop : Icons.videocam,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),

          // Switch camera button
          Positioned(
            bottom: 30,
            right: 20,
            child: IconButton(
              onPressed: _switchCamera,
              icon: const Icon(Icons.switch_camera, color: Colors.white),
              iconSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  // Format recording time as mm:ss
  String _formatRecordingTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
