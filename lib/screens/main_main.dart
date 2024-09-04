import 'package:flutter/material.dart';
import 'package:kkh_events/admin/main.dart';

import 'package:kkh_events/screens/components/BottomBar.dart';
import 'package:kkh_events/screens/swipe_screen.dart';

class MainMainScreen extends StatefulWidget {
  @override
  _MainMainScreenState createState() => _MainMainScreenState();
}

class _MainMainScreenState extends State<MainMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MainScreen(),
    Admin(),
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
