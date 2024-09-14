import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/routes/jumbledPost.dart';
import 'package:kkh_events/api/routes/profile_post.dart';
import 'package:kkh_events/screens/profile_screen.dart';
import 'package:kkh_events/screens/reel_screen.dart'; // Import ReelScreen
import 'package:video_player/video_player.dart';

class PostflowScreen<T> extends StatefulWidget {
  final List<T> posts;
  final int initialIndex; // Added to pass the index you want to jump to

  const PostflowScreen({Key? key, required this.posts, this.initialIndex = 0})
      : super(key: key);

  @override
  _PostflowScreenState<T> createState() => _PostflowScreenState<T>();
}

class _PostflowScreenState<T> extends State<PostflowScreen<T>> {
  late ScrollController _scrollController;
  int? mainuserId;
  Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _scrollController = ScrollController();

    // Scroll to the desired index when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIndex > 0 &&
          widget.initialIndex < widget.posts.length) {
        _scrollController.animateTo(
          widget.initialIndex * 600.0, // Adjust if the height differs
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _videoControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController, // Use the ScrollController
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          return _buildPostView(widget.posts[index], index);
        },
      ),
    );
  }

  Widget _buildPostView(T post, int index) {
    String? profilePic;
    String? username;
    String? mediaUrl;
    String? mediaType;
    String? content;
    String? createdAt;
    int? userid;

    if (post is Posts) {
      profilePic = post.profilePic;
      username = post.username;
      mediaUrl = post.mediaUrl;
      mediaType = post.mediaType;
      content = post.content;
      createdAt = post.createdAt;
      userid = post.userId;
    } else if (post is JumbledPostAPI) {
      profilePic = post.profilePic;
      username = post.username;
      mediaUrl = post.mediaUrl;
      mediaType = post.mediaType;
      content = post.content;
      createdAt = post.createdAt;
      userid = post.userId;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(profilePic ?? ''),
          ),
          title: Text(
            username ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.more_vert),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userId: userid,
                  mainuserId: mainuserId,
                ),
              ),
            );
          },
        ),
        mediaType == 'video' && mediaUrl != null && mediaUrl.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReelScreen(
                        reels: widget.posts.where((post) {
                          if (post is Posts) {
                            return post.mediaType == 'video';
                          } else if (post is JumbledPostAPI) {
                            return post.mediaType == 'video';
                          }
                          return false;
                        }).map((post) {
                          if (post is Posts) {
                            return {
                              'mediaUrl':
                                  post.mediaUrl ?? '', // Handle null safety
                              'username': post.username ?? '',
                              'profilePic': post.profilePic ?? '',
                              'content': post.content ?? '',
                              'createdAt': post.createdAt ?? '',
                            };
                          } else if (post is JumbledPostAPI) {
                            return {
                              'mediaUrl': post.mediaUrl ?? '',
                              'username': post.username ?? '',
                              'profilePic': post.profilePic ?? '',
                              'content': post.content ?? '',
                              'createdAt': post.createdAt ?? '',
                            };
                          }
                          return <String, String?>{}; // Empty map as fallback
                        }).toList(),
                        initialIndex:
                            index, // Pass the index of the tapped video
                      ),
                    ),
                  );
                },
                child: _buildVideoPlayer(index, mediaUrl!),
              )
            : mediaUrl != null && mediaUrl.isNotEmpty
                ? Image.network(
                    mediaUrl!,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : _buildBrokenImage(),
      ],
    );
  }

  Widget _buildVideoPlayer(int index, String videoUrl) {
    if (!_videoControllers.containsKey(index)) {
      _videoControllers[index] = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {
            _videoControllers[index]?.play();
          });
        }).catchError((error) {
          print("Video player error: $error"); // Handle error here
        });
    }

    VideoPlayerController controller = _videoControllers[index]!;

    return controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          )
        : _buildShimmerEffect();
  }

  Widget _buildBrokenImage() {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: 64,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      width: double.infinity,
      height: 400,
      color: Colors.grey[300],
    );
  }

  Future<void> _fetchUserId() async {
    UserProvider userProvider = UserProvider();
    int? fetchedUserId = await userProvider.userId;
    setState(() {
      mainuserId = fetchedUserId;
    });
  }
}
