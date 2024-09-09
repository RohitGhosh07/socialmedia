import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart'; // For accessing gallery images and videos
import 'package:image_picker/image_picker.dart'; // For capturing images
import 'package:permission_handler/permission_handler.dart'; // For requesting permissions

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  AssetEntity? selectedMedia;
  List<AssetEntity> galleryMedia = [];

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndLoadMedia();
  }

  Future<void> _requestPermissionsAndLoadMedia() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      // Request permissions
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      _loadGalleryMedia(); // Load gallery media after permission is granted
    } else if (status.isDenied) {
      // Permission denied, handle accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied to access gallery.')),
      );
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      openAppSettings();
    }
  }

  Future<void> _loadGalleryMedia() async {
    List<AssetPathEntity> imageAlbums = [];
    List<AssetPathEntity> videoAlbums = [];

    // Load images
    imageAlbums = await PhotoManager.getAssetPathList(type: RequestType.image);

    // Check if there are any image albums
    if (imageAlbums.isNotEmpty) {
      final imageAlbum = imageAlbums.first;
      final imageAssets =
          await imageAlbum.getAssetListRange(start: 0, end: 100);
      galleryMedia.addAll(imageAssets);
    }

    // Load videos
    videoAlbums = await PhotoManager.getAssetPathList(type: RequestType.video);

    // Check if there are any video albums
    if (videoAlbums.isNotEmpty) {
      final videoAlbum = videoAlbums.first;
      final videoAssets =
          await videoAlbum.getAssetListRange(start: 0, end: 100);
      galleryMedia.addAll(videoAssets);
    }

    setState(() {
      selectedMedia = galleryMedia.isNotEmpty ? galleryMedia.first : null;
    });

    // Handle case where no media was found
    if (galleryMedia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No media found in the gallery.')),
      );
    }
  }

  Future<void> _selectMedia(AssetEntity media) async {
    setState(() {
      selectedMedia = media;
    });
  }

  Future<void> _selectMediaOption(
      BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final fileBytes = await pickedFile.readAsBytes();
      final fileEntity = await PhotoManager.editor.saveImage(
        fileBytes,
        filename: pickedFile.name,
      );
      setState(() {
        selectedMedia = fileEntity;
      });
    }
  }

  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _selectMediaOption(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _loadGalleryMedia();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        actions: [
          TextButton(
            onPressed: () {
              // Logic to post the image/video with the caption
              print('Posted media: ${selectedMedia?.id}');
            },
            child: const Text(
              'Share',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Square area to show the selected media
          AspectRatio(
            aspectRatio: 1,
            child: selectedMedia != null
                ? FutureBuilder<Uint8List?>(
                    future: selectedMedia!
                        .thumbnailDataWithSize(const ThumbnailSize(500, 500)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : Container(color: Colors.grey[300]),
          ),
          // Bottom bar with buttons
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () => _showMediaOptions(context),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose from Gallery'),
                ),
                TextButton.icon(
                  onPressed: () => _showMediaOptions(context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ],
            ),
          ),
          // Gallery images and videos in a grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(4.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: galleryMedia.length,
              itemBuilder: (context, index) {
                final media = galleryMedia[index];
                return GestureDetector(
                  onTap: () => _selectMedia(media),
                  child: FutureBuilder<Uint8List?>(
                    future: media
                        .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Stack(
                          children: [
                            Image.memory(snapshot.data!, fit: BoxFit.cover),
                            if (media == selectedMedia)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  color: Colors.blue.withOpacity(0.5),
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
