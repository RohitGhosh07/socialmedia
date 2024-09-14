import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kkh_events/api/routes/createpost.dart';
import 'package:kkh_events/screens/ReelPostScreen.dart';
import 'package:kkh_events/screens/components/CustomNotification.dart';
import 'package:kkh_events/screens/profile_screen.dart';
import 'package:photo_manager/photo_manager.dart'; // For accessing gallery images and videos
import 'package:image_picker/image_picker.dart'; // For capturing images
import 'package:permission_handler/permission_handler.dart'; // For requesting permissions

class PostScreen extends StatefulWidget {
  final int userId; // Pass the user ID to this screen

  const PostScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  AssetEntity? selectedMedia;
  List<AssetEntity> galleryMedia = [];
  final TextEditingController captionController =
      TextEditingController(); // Controller for caption

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndLoadMedia();
    // print("User ID: ${widget.userId}");
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

  Future<void> _postMedia() async {
    if (selectedMedia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No media selected')),
      );
      return;
    }

    // Determine the media type (image or video) based on AssetEntity's type
    String mediaType = _getMediaType(selectedMedia!);

    if (mediaType == 'unsupported') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Unsupported file type. Only JPG, PNG, GIF, and MP4 are allowed.')),
      );
      return;
    }

    print("Caption: ${captionController.text}");
    print("Media: $selectedMedia");
    print("User ID: ${widget.userId}");
    print("Media Type: $mediaType");

    try {
      await CreatePostAPI.postcreation(
        captionController.text, // Post content
        selectedMedia!, // Passing AssetEntity as media
        mediaType, // Correct media type (image or video)
        widget.userId, // User ID
      );
      CustomNotification.show(context, "Post created successfully");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ProfileScreen(
      //       userId:
      //           widget.userId, // Pass the user ID or other necessary parameters
      //     ),
      //   ),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e.toString()}')),
      );
    }
  }

// Helper function to determine media type
  String _getMediaType(AssetEntity media) {
    if (media.type == AssetType.image) {
      if (media.mimeType == 'image/jpeg' ||
          media.mimeType == 'image/jpg' ||
          media.mimeType == 'image/png' ||
          media.mimeType == 'image/gif') {
        return 'image';
      }
    } else if (media.type == AssetType.video) {
      if (media.mimeType == 'video/mp4') {
        return 'video';
      }
    }
    return 'unsupported'; // Return unsupported if the media type is not allowed
  }

  int _selectedIndex = 0; // To track which screen is active

  // This function handles the bottom bar navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Main post screen UI (Your original post UI)
  Widget _postScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        actions: [
          TextButton(
            onPressed: _postMedia, // Post the media
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
          // Caption input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: captionController,
              decoration: const InputDecoration(
                labelText: 'Write a caption...',
                border: OutlineInputBorder(),
              ),
            ),
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
                            AspectRatio(
                                aspectRatio: 1,
                                child: Image.memory(snapshot.data!,
                                    fit: BoxFit.cover)),
                            if (media == selectedMedia)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  color: Colors.white.withOpacity(0.8),
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

  // Main build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
          true, // This allows the BottomNavigationBar to float over the body
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _postScreen(),
          ReelCameraScreen(
            userId: widget.userId, // This can be replaced with ReelScreen()
          ), // This can be replaced with ReelScreen()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 60.0, vertical: 10.0), // Padding for gaps on the sides
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Rounded edges
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.black
                .withOpacity(0.8), // Semi-transparent dark background
            type: BottomNavigationBarType
                .fixed, // To maintain fixed size of icons and text
            showSelectedLabels: true, // Show only text labels
            showUnselectedLabels: true, // Same for unselected items
            selectedItemColor: Colors.white, // Color for the selected text
            unselectedItemColor: Colors.grey, // Color for the unselected text
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SizedBox.shrink(), // Remove icon to show only text
                label: 'Posts', // Text label
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(), // Remove icon to show only text
                label: 'Zips', // Text label
              ),
            ],
          ),
        ),
      ),
    );
  }
}
