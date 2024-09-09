import 'package:flutter/material.dart';
import 'package:kkh_events/screens/home_screen.dart';
import 'package:kkh_events/screens/notification_screen.dart';
import 'package:kkh_events/screens/post_screen.dart';
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

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    PostScreen(),
    MainScreen(),
    ProfileScreen(
      userId: 12,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the current screen
      bottomNavigationBar: BottomBar(
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
