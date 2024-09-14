import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/class/User.dart';
import 'package:kkh_events/screens/ReelPostScreen.dart'; // Replace this if not needed
import 'package:kkh_events/screens/home_screen.dart';
import 'package:kkh_events/screens/post_posting_screen.dart';
import 'package:kkh_events/screens/profile_screen.dart';
import 'package:kkh_events/screens/components/BottomBar.dart';
import 'package:kkh_events/screens/search_screen.dart';
import 'package:kkh_events/screens/swipe_screen.dart';

class MainMainScreen extends StatefulWidget {
  const MainMainScreen({super.key});

  @override
  _MainMainScreenState createState() => _MainMainScreenState();
}

class _MainMainScreenState extends State<MainMainScreen> {
  int _currentIndex = 0;
  int? userId; // Store userId here
  String? profilePic;
  List<Widget> _screens = [];
  int? mainuserId;

  @override
  void initState() {
    super.initState();
    usegetUser(); // Fetch user data when the screen initializes
    _fetchUserId(); // Call the async method to fetch user ID
  }

  Future<void> _fetchUserId() async {
    UserProvider userProvider = UserProvider();
    int? fetchedUserId = await userProvider.userId; // Await the Future
    print(fetchedUserId);
    setState(() {
      mainuserId = fetchedUserId; // Update the state with the fetched user ID
    });
  }

  Future<void> usegetUser() async {
    UserProvider userProvider = UserProvider();
    User? user = await userProvider.getUser(); // Get the user data

    if (user != null) {
      setState(() {
        userId = user.id; // Set the user ID
        profilePic = user.profilePic;
        _initializeScreens(); // Initialize the screens after setting userId
        print(userId);
      });
    } else {
      _initializeScreens(); // Initialize screens even if userId is null
    }
  }

  void _initializeScreens() {
    _screens = [
      HomeScreen(
        userId: userId ?? 0, // Use a default value if userId is null
      ),
      SearchScreen(),
      // Replace this with any other screen or leave it out
      PostScreen(userId: userId ?? 0), // Use a default value if userId is null
      // ReelCameraScreen(), // Replace ReelCameraScreen with ReelPostScreen or another widget
      const MainScreen(),
      ProfileScreen(
        userId: userId, // Use a default value if userId is null
        mainuserId: userId,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.isNotEmpty
          ? _screens[_currentIndex]
          : Container(), // Display the current screen
      bottomNavigationBar: BottomBar(
        profilePic: profilePic ?? '', // Provide a default value for profilePic
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index; // Update the active screen index
          });
        },
      ),
    );
  }
}
