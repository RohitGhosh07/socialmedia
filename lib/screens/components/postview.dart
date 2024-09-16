import 'dart:developer';
import 'package:get/get.dart';
import 'package:kkh_events/api/routes/postcomment.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/routes/getcomments.dart';
import 'package:kkh_events/api/routes/liketoggle.dart';
import 'package:kkh_events/api/routes/profile_post.dart';
import 'package:kkh_events/screens/profile_screen.dart';
import 'package:kkh_events/screens/reel_screen.dart';
import 'package:video_player/video_player.dart';

class Postview extends StatefulWidget {
  final Posts post;
  final List<Posts>? posts;
  final int index;
  const Postview(
      {super.key, required this.post, required this.index, this.posts});

  @override
  State<Postview> createState() => _PostviewState();
}

class _PostviewState extends State<Postview> {
  String? profilePic;
  String? username;
  String? mediaUrl;
  String? mediaType;
  String? content;
  String? createdAt;
  int? userId;
  String? likeCount;
  String? commentCount;
  bool isLiked = false; // Track if the post is liked
  final Map<int, VideoPlayerController> _videoControllers = {};
  int? mainuserId;
  late Future<List<GetCommentAPI>> _commentList;
  TextEditingController _commentController = TextEditingController();
  bool _isPosting = false; // To handle the posting state

  Future<void> _fetchUserId() async {
    UserProvider userProvider = UserProvider();
    int? fetchedUserId = await userProvider.userId;
    setState(() {
      mainuserId = fetchedUserId;
    });
  }

  Future<void> _postComment() async {
    final String commentText = _commentController.text.trim();

    // Ensure the comment text is not empty
    if (commentText.isEmpty) {
      return; // Don't allow empty comments
    }

    // Ensure the post's userId is not null
    if (widget.post.id == null || widget.post.id == null) {
      print(
          "Error: Post userId or post id is null,${widget.post.id}, ${widget.post.id}");
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      // Call the API to post a new comment
      await PostCommentAPI.postcomment(
          widget.post
              .userId!, // Safely unwrap userId here since we've checked for null
          widget.post
              .id!, // Safely unwrap postId here since we've checked for null
          commentText);

      // Clear the input field
      _commentController.clear();

      // Refresh the comment list
      setState(() {
        _fetchComments();
      });
    } catch (e) {
      // Handle error
      print(
          "Error posting comment: $e, ${widget.post.userId}, ${widget.post.id}");
    } finally {
      setState(() {
        _isPosting = false;
      });
    }
  }

  @override
  void initState() {
    profilePic = widget.post.profilePic;
    username = widget.post.username;
    mediaUrl = widget.post.mediaUrl;
    mediaType = widget.post.mediaType;
    content = widget.post.content;
    createdAt = widget.post.createdAt;
    userId = widget.post.userId;
    likeCount = widget.post.likeCount;
    commentCount = widget.post.likeCount;
    _fetchUserId();
    _fetchComments();

    super.initState();
  }

  void _fetchComments() {
    // Fetch the comment list from the API
    _commentList = GetCommentAPI.commentlist(widget.post.id!);
  }

  Future<void> _toggleLike() async {
    if (mainuserId == null) return; // Make sure user is logged in
    try {
      final response = await LikeAPI.liking(mainuserId!, widget.post.userId!);
      setState(() {
        isLiked = !isLiked;
        likeCount = isLiked
            ? (int.parse(likeCount ?? '0') + 1).toString()
            : (int.parse(likeCount ?? '0') - 1).toString();
      });
    } catch (e) {
      log('Error liking post: $e');
    }
  }

  // Helper function to format timestamp
  String formatTimestamp(String timestamp) {
    DateTime time = DateTime.parse(timestamp);
    return timeago.format(time, allowFromNow: true); // Shows "X time ago"
  }

  @override
  Widget build(BuildContext context) {
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
                  userId: userId,
                  mainuserId: mainuserId,
                ),
              ),
            );
          },
        ),
        mediaType == 'video' &&
                mediaUrl != null &&
                (mediaUrl?.isNotEmpty ?? false)
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReelScreen(
                        reels: widget.posts?.where((post) {
                              return post.mediaType == 'video';
                            }).map((post) {
                              return {
                                'mediaUrl': post.mediaUrl ?? '',
                                'username': post.username ?? '',
                                'profilePic': post.profilePic ?? '',
                                'content': post.content ?? '',
                                'createdAt': post.createdAt ?? '',
                              };
                            }).toList() ??
                            [],
                        initialIndex: widget.index,
                      ),
                    ),
                  );
                },
                child: _buildVideoPlayer(widget.index, mediaUrl!),
              )
            : mediaUrl != null && (mediaUrl?.isNotEmpty ?? false)
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
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.black,
                ),
                onPressed: _toggleLike,
              ),
              Text(likeCount ?? '0'),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled:
                        true, // Allow modal to take more screen space
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => DraggableScrollableSheet(
                      expand: false, // Allows to drag the sheet up and down
                      initialChildSize:
                          0.85, // Takes 85% of the screen initially
                      minChildSize: 0.5, // Minimum size is 50% of the screen
                      maxChildSize: 0.9, // Maximum is 90% of the screen
                      builder: (context, scrollController) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Drag handle
                              Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: 40,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Title or heading
                              const Text(
                                'Comments',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Divider(),
                              // Comment list from the API
                              Expanded(
                                child: FutureBuilder<List<GetCommentAPI>>(
                                  future: _commentList,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Center(
                                        child: Text('No comments yet.'),
                                      );
                                    } else {
                                      return ListView.builder(
                                        controller: scrollController,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          final comment = snapshot.data![index];
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                comment.user?.profilePic ??
                                                    'https://placekitten.com/200/200', // Placeholder for profile image if null
                                              ),
                                            ),
                                            title: Text(
                                                comment.user?.username ??
                                                    'Unknown User'),
                                            subtitle: Text(comment.text ??
                                                'No comment text'),
                                            trailing: Text(
                                              formatTimestamp(
                                                  comment.createdAt ?? ''),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                              // Comment input field
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _commentController,
                                        decoration: InputDecoration(
                                          hintText: 'Add a comment...',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: _isPosting
                                          ? const CircularProgressIndicator()
                                          : const Icon(Icons.send),
                                      onPressed: _isPosting
                                          ? null
                                          : _postComment, // Disable button if posting
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
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
      _videoControllers[index] =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl))
            ..initialize().then((_) {
              setState(() {
                _videoControllers[index]?.play();
              });
            }).catchError((error) {
              log("Video player error: $error");
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
}
