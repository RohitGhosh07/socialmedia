import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/Webservices.dart'; // Import the API file
import 'package:kkh_events/api/routes/profile.dart';
import 'package:kkh_events/api/routes/profile_post.dart';
import 'package:kkh_events/screens/loginAndSignup_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final int userId; // Pass the user ID to the screen

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user; // Store the user details
  ProfilePostAPI? profilePostData; // Store the user's posts
  bool isLoading = true; // State for loading
  bool hasError = false; // State for error handling

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch both user details and posts
  }

  // Fetch profile details and posts
  Future<void> _fetchProfileData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch profile data
      ProfileAPI userResponse = await ProfileAPI.profile(widget.userId);
      ProfilePostAPI postResponse =
          await ProfilePostAPI.profilepost(widget.userId);

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
              _showBottomSheet(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loader when fetching data
          : hasError
              ? const Center(
                  child: Text(
                    'Error fetching data. Please try again later.',
                    style: TextStyle(color: Colors.red),
                  ),
                ) // Show error message
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileHeader(), // Builds the profile header (avatar, stats)
                        const SizedBox(height: 16),
                        _buildUserInfo(), // Displays username and bio
                        const SizedBox(height: 16),
                        profilePostData != null
                            ? _buildTabView() // Show posts if available
                            : const Center(
                                child:
                                    CircularProgressIndicator()), // Fallback for posts loading
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
              _buildStatColumn('100', 'Posts'),
              _buildStatColumn('10k', 'Followers'),
              _buildStatColumn('500', 'Following'),
            ],
          ),
        ),
      ],
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
          SizedBox(
            height: 400, // Limit the height for proper scrolling
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
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            profilePostData!.posts![index].mediaUrl ?? '',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: profilePostData?.posts?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user?.profilePic ?? '',
                        ),
                      ),
                      title: Text(profilePostData!.posts![index].content ??
                          'No content'),
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

  // Helper function to build stats columns
  Column _buildStatColumn(String count, String label) {
    return Column(
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
