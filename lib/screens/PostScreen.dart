import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/routes/jumbledPost.dart';
import 'package:kkh_events/api/routes/profile_post.dart';
import 'package:kkh_events/screens/components/postview.dart';
import 'package:kkh_events/screens/profile_screen.dart';
import 'package:kkh_events/screens/reel_screen.dart'; // Import ReelScreen
import 'package:video_player/video_player.dart';

class PostflowScreen<Widget> extends StatefulWidget {
  final List<Posts> posts;
  final int initialIndex;

  const PostflowScreen({super.key, required this.posts, this.initialIndex = 0});

  @override
  _PostflowScreenState<Widget> createState() => _PostflowScreenState<Widget>();
}

class _PostflowScreenState<T> extends State<PostflowScreen<T>> {
  late ScrollController _scrollController;
  int? mainuserId;
  final Map<int, VideoPlayerController> _videoControllers = {};

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
          return Postview(
              post: widget.posts[index], index: index, posts: widget.posts);
        },
      ),
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
