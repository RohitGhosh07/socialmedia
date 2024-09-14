import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kkh_events/api/routes/videopost.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EditVideoScreen extends StatefulWidget {
  final File videoFile;
  final File defaultThumbnail;
  final int userId;

  const EditVideoScreen({
    Key? key,
    required this.videoFile,
    required this.defaultThumbnail,
    required this.userId,
  }) : super(key: key);

  @override
  _EditVideoScreenState createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  File? _customThumbnail;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  Future<void> _pickCustomThumbnail() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _customThumbnail = File(image.path);
      });
    }
  }

  Future<File> _moveFileToExternalStorage(File file) async {
    Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir != null) {
      String newPath = '${externalDir.path}/${file.path.split('/').last}';
      return await file.copy(newPath);
    }
    return file;
  }

  Future<void> _shareVideo() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final thumbnailToShare = _customThumbnail ?? widget.defaultThumbnail;
      File newVideoFile = await _moveFileToExternalStorage(widget.videoFile);
      File newThumbnailFile =
          await _moveFileToExternalStorage(thumbnailToShare);

      await VideoPostAPI.postcreation(
        "This is the post content",
        newVideoFile,
        "video",
        widget.userId,
        newThumbnailFile,
      );
    } catch (e) {
      print("Error during upload: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Edit Video"),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: _shareVideo,
            child: _isUploading
                ? CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Share",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Centered video thumbnail card with 9:16 ratio
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        _customThumbnail != null
                            ? Image.file(
                                _customThumbnail!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                widget.defaultThumbnail,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: MediaQuery.of(context).size.width / 2 - 60,
                          child: GestureDetector(
                            onTap: _pickCustomThumbnail,
                            child: Row(
                              children: [
                                Icon(Icons.photo_library, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  "Change Thumbnail",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Comment Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
