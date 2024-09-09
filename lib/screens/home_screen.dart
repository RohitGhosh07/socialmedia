import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kkh_events/screens/chat_screen.dart';
import 'package:kkh_events/screens/components/BottomBar.dart';
import 'package:kkh_events/screens/notification_screen.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://picsum.photos/v2/list?limit=10'));
    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
        isLoading = false;
      });
    }
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
          'assets/images/2 - Copy.png', // Replace with your image asset path
          height: 40, // Adjust the height as needed
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications action
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.forum),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
        ],
      ),

      body: posts.isEmpty && isLoading
          ? ListView.builder(
              itemCount: 10, // Show 10 placeholders while loading
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shimmer effect for the post header
                    ListTile(
                      leading: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      title: Container(
                        height: 16,
                        width: 100,
                        color: Colors.grey[300],
                      ),
                      trailing: Icon(Icons.more_vert, color: Colors.grey),
                    ),
                    // Shimmer effect for the post image
                    _buildShimmerEffect(),
                    // Placeholder for post actions and captions
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
                final post = posts[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post Header
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=${index + 1}',
                        ),
                      ),
                      title: Text(
                        'User $index',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(Icons.more_vert),
                    ),
                    // Post Image
                    Image.network(
                      post['download_url'],
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildShimmerEffect();
                      },
                    ),
                    // Post Actions (like, comment, share)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {},
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.bookmark_border),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    // Post Likes and Caption
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Liked by user1 and others',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'User $index: Great picture!',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'View all comments',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '5 minutes ago',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
      // bottomNavigationBar: BottomBar(),
    );
  }
}
