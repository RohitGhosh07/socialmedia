import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/Webservices.dart'; // Import the API file
import 'package:kkh_events/api/class/User.dart';
import 'package:kkh_events/api/routes/follower.dart';
import 'package:kkh_events/api/routes/following.dart';
import 'package:kkh_events/api/routes/followuser.dart';
import 'package:kkh_events/api/routes/profile.dart';
import 'package:kkh_events/api/routes/profile_post.dart';
import 'package:kkh_events/screens/followingfollower_screen.dart';
import 'package:kkh_events/screens/loginAndSignup_screen.dart';
import 'package:kkh_events/screens/PostScreen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId; // Pass the user ID to the screen
  final int? mainuserId; // Pass the user ID to the screen

  const ProfileScreen(
      {Key? key, required this.userId, required this.mainuserId})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user; // Store the user details
  ProfilePostAPI? profilePostData; // Store the user's posts
  bool isLoading = true; // State for loading
  bool hasError = false; // State for error handling
  int? defauultuserId; // Pass the user ID to the screen
  int? followers; // Pass the user ID to the screen
  int? following; // Pass the user ID to the screen

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch both user details and posts
    usergetUser(); // Fetch the user ID
    _fetchFollowerData();
    _fetchFollowingData();
  }

  // Fetch profile details and posts
  Future<void> _fetchProfileData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch profile data
      ProfileAPI userResponse =
          await ProfileAPI.profile(widget.userId!, widget.mainuserId!);
      ProfilePostAPI postResponse =
          await ProfilePostAPI.profilepost(widget.userId!);

      setState(() {
        user = userResponse.user; // Update user details
        profilePostData = postResponse; // Update posts data
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print("Error fetching profile data: $e");
    }
  }

  Future<void> usergetUser() async {
    UserProvider userProvider = UserProvider();
    User? user = await userProvider.getUser(); // Get the user data

    if (user != null) {
      setState(() {
        defauultuserId = user.id; // Set the user ID
      });
    }
  }

  Future<void> _fetchFollowerAndFollowingData() async {
    try {
      FollowerAPI followerAPI = FollowerAPI();
      FollowingAPI followingAPI = FollowingAPI();

      // Fetch followers and following data concurrently
      final FollowerAPI followerResult =
          await followerAPI.followerlist(widget.userId!);
      final FollowingAPI followingResult =
          await followingAPI.followinglist(widget.userId!);

      // Navigate to the FollowingFollowerScreen with the fetched data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FollowingFollowerScreen(
            followerList: followerResult.followers ?? [], // fetched followers
            followingList: followingResult.following ?? [], // fetched following
          ),
        ),
      );
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<void> _fetchFollowerData() async {
    try {
      FollowerAPI followerAPI = FollowerAPI();
      FollowerAPI result = await followerAPI.followerlist(widget.userId!);
      setState(() {
        followers = result.followerCount;
        isLoading = false;
      });
    } catch (e) {
      print("Failed to load followers: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchFollowingData() async {
    try {
      FollowingAPI followingAPI = FollowingAPI();
      FollowingAPI result = await followingAPI.followinglist(widget.userId!);
      setState(() {
        following = result.followingCount;
        isLoading = false;
      });
    } catch (e) {
      print("Failed to load followers: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _toggleFollowStatus() async {
    setState(() {
      isLoading = true; // Show loading indicator while API call is in progress
    });

    try {
      // Call the follow/unfollow API
      FollowUserAPI followResponse = await FollowUserAPI.followuser(
        widget.mainuserId!, // Follower ID (your user)
        widget.userId!, // Following ID (user to be followed/unfollowed)
      );

      // Update the user's following status based on API response
      if (followResponse.action == 'followed') {
        setState(() {
          user?.following = true; // Mark user as followed
        });
      } else if (followResponse.action == 'unfollowed') {
        setState(() {
          user?.following = false; // Mark user as unfollowed
        });
      }
    } catch (e) {
      print("Error: $e");
      // Handle error, e.g., show a snackbar or alert
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          user?.username ?? 'Loading...',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Show loader when fetching data
            )
          : hasError
              ? const Center(
                  child: Text(
                    'Error fetching data. Please try again later.',
                    style: TextStyle(color: Colors.red),
                  ),
                ) // Show error message
              : RefreshIndicator(
                  onRefresh: _fetchProfileData, // Pull-to-refresh action
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileHeader(),
                              const SizedBox(height: 16),
                              _buildUserInfo(), // Displays username and bio
                              if (widget.userId != defauultuserId)
                                _followmesseageemailbuttons()
                            ],
                          ),
                        ), // Builds the profile header (avatar, stats)

                        // const SizedBox(height: 16),
                        profilePostData != null
                            ? Expanded(
                                child:
                                    _buildTabView()) // Show posts if available
                            : const Center(
                                child: CircularProgressIndicator(),
                              ), // Fallback for posts loading
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: user?.profilePic != null
              ? NetworkImage(user!.profilePic!)
              : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn(
                  '${profilePostData?.user?.postCount ?? 0}', 'Posts', false),
              _buildStatColumn('$followers', 'Followers', true),
              _buildStatColumn('$following', 'Following', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String count, String label, bool isRedirect) {
    return GestureDetector(
      onTap: isRedirect
          ? () {
              _fetchFollowerAndFollowingData();
            }
          : null, // No action if `isRedirect` is false
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user?.username ?? 'Your Name',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user?.bio ?? 'Your bio goes here. It can be multiple lines.',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _followmesseageemailbuttons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : _toggleFollowStatus, // Disable button while loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: (user != null && user!.following == true)
                      ? Colors.white
                      : Colors
                          .blue, // White background if following, blue otherwise
                  fixedSize: const Size(120,
                      40), // Set a fixed size for the button (adjust width & height as needed)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color:
                          Colors.blue, // Blue border for the 'Following' state
                      width: (user != null && user!.following == true)
                          ? 2.0
                          : 0.0, // Thicker border if following
                    ),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator() // Show a loading indicator if API call is in progress
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          (user != null && user!.following == true)
                              ? 'Following' // Show "Following" if following
                              : (user != null && user!.follower == true)
                                  ? 'Follow Back' // Show "Follow Back" if they are following you
                                  : 'Follow', // Default text "Follow"
                          style: TextStyle(
                            color: (user != null && user!.following == true)
                                ? Colors.blue
                                : Colors
                                    .white, // Blue text for "Following", white text otherwise
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle message button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Message',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle email button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Email',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabView() {
    return DefaultTabController(
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
          Expanded(
            child: TabBarView(
              children: [
                GridView.builder(
                  itemCount: profilePostData?.posts?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    final post = profilePostData!.posts![index];

                    return GestureDetector(
                      onTap: () => _navigateToPostflowScreen(
                          index), // Navigate to postflow screen on tap
                      child: Container(
                        decoration: BoxDecoration(
                          image: post.mediaType == 'video'
                              ? DecorationImage(
                                  image: NetworkImage(post.thumbNail ??
                                      ''), // Use video thumbnail URL
                                  fit: BoxFit.cover,
                                )
                              : post.mediaUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(post.mediaUrl ?? ''),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                          color: post.mediaUrl == null &&
                                  !(post.mediaType == 'video')
                              ? Colors
                                  .grey[300] // Fallback color for empty content
                              : null,
                        ),
                        child: post.mediaType == 'video'
                            ? Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.play_circle_fill,
                                    color:
                                        Colors.white54), // Play icon for video
                              )
                            : null,
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: profilePostData?.posts?.length ?? 0,
                  itemBuilder: (context, index) {
                    final post = profilePostData!.posts![index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user?.profilePic ?? '',
                        ),
                      ),
                      title: Text(post.content ?? 'No content'),
                      subtitle: post.mediaType == 'video'
                          ? Text('Video')
                          : null, // Optional subtitle to indicate video
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPostflowScreen(int selectedIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostflowScreen(
          posts: profilePostData!.posts!, // Pass the list of posts
          initialIndex: selectedIndex, // Pass the index of the selected post
        ),
      ),
    );
  }

  // Function to show the bottom sheet for menu options
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                onTap: () {
                  // Handle edit profile action
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Handle settings action
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  var userProvider = UserProvider();
                  await userProvider.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginAndSignupScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
