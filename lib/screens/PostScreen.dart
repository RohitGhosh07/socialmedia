import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/routes/jumbledPost.dart';
import 'package:kkh_events/api/routes/profile_post.dart';
import 'package:kkh_events/screens/profile_screen.dart';
import 'package:kkh_events/screens/reel_screen.dart'; // Import ReelScreen
import 'package:video_player/video_player.dart';

class PostflowScreen<T> extends StatefulWidget {
  final List<T> posts;
  final int initialIndex;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIndex > 0 &&
          widget.initialIndex < widget.posts.length) {
        _scrollController.animateTo(
          widget.initialIndex * 600.0,
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
        controller: _scrollController,
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
    String? likeCount;
    String? commentCount;

    if (post is Posts) {
      profilePic = post.profilePic;
      username = post.username;
      mediaUrl = post.mediaUrl;
      mediaType = post.mediaType;
      content = post.content;
      createdAt = post.createdAt;
      userid = post.userId;
      likeCount = post.likeCount;
      commentCount = post.likeCount;
    } else if (post is JumbledPostAPI) {
      profilePic = post.profilePic;
      username = post.username;
      mediaUrl = post.mediaUrl;
      mediaType = post.mediaType;
      content = post.content;
      createdAt = post.createdAt;
      userid = post.userId;
      likeCount = post.likeCount;
      commentCount = post.likeCount;
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
                              'mediaUrl': post.mediaUrl ?? '',
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
                          return <String, String?>{};
                        }).toList(),
                        initialIndex: index,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              Text(likeCount ?? '0'),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Liked by user1 and others',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${username ?? 'User'}: ${content ?? 'Great picture!'}',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 4),
              const Text(
                'View all comments',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                createdAt ?? '5 minutes ago',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
          print("Video player error: $error");
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

  void _showCommentsBottomModal(BuildContext context, T post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Simulated comments section
            ListTile(
              title: Text('${post is Posts ? post.content : ''}'),
              subtitle: const Text('This is a comment'),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      Navigator.pop(context);
                      // Add logic to submit a comment
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
