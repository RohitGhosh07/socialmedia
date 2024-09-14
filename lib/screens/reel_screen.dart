import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelScreen extends StatefulWidget {
  final List<Map<String, String?>> reels; // Allow nullable values
  final int initialIndex; // The index of the video to start with

  const ReelScreen({
    Key? key,
    required this.reels,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _ReelScreenState createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  PageController _pageController = PageController();
  Map<int, VideoPlayerController> _videoControllers = {};
  Map<int, int> _playCounts = {};
  int _currentReelIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllerForReel(
        widget.initialIndex); // Start from the initial index

    _pageController = PageController(
        initialPage:
            widget.initialIndex); // Set the initial page to the tapped video

    _pageController.addListener(() {
      final newPage = _pageController.page!.round();
      if (newPage != _currentReelIndex) {
        _onReelChanged(newPage);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disposeAllControllers();
    super.dispose();
  }

  // Initialize video controller for the given reel index
  void _initializeControllerForReel(int index) {
    if (!_videoControllers.containsKey(index)) {
      final videoUrl = widget.reels[index]['mediaUrl']!;
      final controller = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {
            _videoControllers[index]!.play();
          });
        });
      _videoControllers[index] = controller;
      _playCounts[index] = 0; // Initialize play count
    }
  }

  // Dispose all video controllers
  void _disposeAllControllers() {
    _videoControllers.forEach((index, controller) {
      controller.dispose();
    });
  }

  // Handle switching between reels
  void _onReelChanged(int newIndex) {
    setState(() {
      _videoControllers[_currentReelIndex]?.pause(); // Pause the old reel
      _currentReelIndex = newIndex; // Update to the new reel index
      _initializeControllerForReel(newIndex); // Initialize new reel video
    });
  }

  // Build each reel view
  Widget _buildReelView(int index) {
    final controller = _videoControllers[index]!;
    final playCount = _playCounts[index] ?? 0;

    return GestureDetector(
      onTap: () {
        // Pause or resume the video when tapped
        setState(() {
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        });
      },
      child: Stack(
        children: [
          Center(
            child: controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  )
                : const CircularProgressIndicator(),
          ),
          _buildOverlayContent(index),
          if (playCount >= 2)
            _buildRewatchPrompt(
                controller), // Show rewatch prompt after 2 plays
        ],
      ),
    );
  }

  // Overlay content (profile info, etc.)
  Widget _buildOverlayContent(int index) {
    return Positioned(
      left: 16,
      bottom: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.reels[index]['profilePic']!),
              ),
              const SizedBox(width: 8),
              Text(
                widget.reels[index]['username']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.reels[index]['content']!,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            widget.reels[index]['createdAt']!,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Prompt asking if user wants to rewatch the video
  Widget _buildRewatchPrompt(VideoPlayerController controller) {
    return Center(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Do you want to rewatch?",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _playCounts[_currentReelIndex] = 0;
                      controller.play();
                    });
                  },
                  child: const Text("Rewatch"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      controller.pause();
                    });
                  },
                  child: const Text("No"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text("Reels", style: TextStyle(color: Colors.white)),
      //   // centerTitle: true,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: widget.reels.length,
        itemBuilder: (context, index) {
          return _buildReelView(index);
        },
      ),
    );
  }
}
