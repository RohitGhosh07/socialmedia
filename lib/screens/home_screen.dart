import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/class/User.dart';
import 'package:kkh_events/api/routes/followingPost.dart'; // Assuming your API class is here
import 'package:kkh_events/screens/chat_screen.dart';
import 'package:kkh_events/screens/notification_screen.dart';
import 'package:kkh_events/screens/profile_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  final int? userId; // Pass the user ID to the screen

  const HomeScreen({Key? key, required this.userId}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FollowingPostAPI> posts = []; // List to hold posts
  bool isLoading = true;
  int? defauultuserId;
  int? mainuserId;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _fetchUserId(); // Call the async method to fetch user ID
  }

// Async function to fetch user ID and handle Future properly
  Future<void> _fetchUserId() async {
    UserProvider userProvider = UserProvider();
    int? fetchedUserId = await userProvider.userId; // Await the Future
    setState(() {
      mainuserId = fetchedUserId; // Update the state with the fetched user ID
    });
  }

  // Fetch posts from the API
  Future<void> fetchPosts() async {
    try {
      // Fetch posts from followed users
      FollowingPostAPI followingPostsAPI = FollowingPostAPI();
      List<FollowingPostAPI> fetchedPosts = await followingPostsAPI
          .postlist(widget.userId ?? 0); // Fetch list of posts

      setState(() {
        posts = fetchedPosts; // Set the fetched posts
        isLoading = false;
      });
    } catch (e) {
      print("Failed to fetch posts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Pull-to-refresh functionality
  Future<void> _refreshPosts() async {
    setState(() {
      isLoading = true; // Show loading indicator during refresh
    });
    await fetchPosts(); // Fetch updated posts
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 400,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/naiyorounded.png',
          height: 40,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.forum),
            onPressed: () {
              // Handle chat action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    userId: widget.userId!, // Pass the user ID
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts, // Trigger refresh when pulled down
        child: posts.isEmpty && isLoading
            ? ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        title: Container(
                          height: 16,
                          width: 100,
                          color: Colors.grey[300],
                        ),
                        trailing:
                            const Icon(Icons.more_vert, color: Colors.grey),
                      ),
                      _buildShimmerEffect(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16,
                              width: 100,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 16,
                              width: 150,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 16,
                              width: 80,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              )
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index]; // Get the post

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(post.profilePic ?? ''),
                        ),
                        title: Text(
                          post.username ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.more_vert),
                        onTap: () {
                          // Navigate to ProfileScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                userId: post
                                    .userId, // Pass the user ID or other necessary parameters
                                mainuserId: mainuserId!,
                              ),
                            ),
                          );
                        },
                      ),
                      CachedNetworkImage(
                        imageUrl: post.mediaUrl ?? '', // Media URL of the post
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildShimmerEffect(),
                        errorWidget: (context, url, error) => Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey[300]!,
                                Colors.grey[100]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {},
                            ),
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
                              '${post.username ?? 'User'}: ${post.content ?? 'Great picture!'}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'View all comments',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.createdAt ?? '5 minutes ago',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
