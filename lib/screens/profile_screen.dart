import 'package:flutter/material.dart';
import 'package:kkh_events/screens/components/BottomBar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'your_username', // Replace with dynamic username
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile picture
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/profile_picture.jpg'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        // Posts, Followers, Following count
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '100',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Posts',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '10k',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Followers',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '500',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Username and Bio
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Name', // Replace with dynamic name
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your bio goes here. It can be multiple lines.', // Replace with dynamic bio
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Stories Highlights
            Container(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.grey[300],
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/story_$index.jpg'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Highlight ${index + 1}', // Replace with dynamic highlight name
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            // Tabs for Grid/List view
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(icon: Icon(Icons.grid_on, color: Colors.black)),
                      Tab(icon: Icon(Icons.list, color: Colors.black)),
                    ],
                  ),
                  Container(
                    height: 400,
                    child: TabBarView(
                      children: [
                        // Grid view of posts
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 9,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://source.unsplash.com/random/200x200?sig=$index',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                        // List view (optional, could be a list of posts)
                        ListView.builder(
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://source.unsplash.com/random/200x200?sig=$index',
                                ),
                              ),
                              title: Text('Post $index'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomBar(),
    );
  }
}
