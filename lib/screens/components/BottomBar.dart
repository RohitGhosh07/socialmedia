import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const BottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget
        .onTabTapped(index); // Call the provided function to update the screen
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.home_filled,
        //       size: 30,
        //       color: _selectedIndex == 0 ? Colors.black : Colors.grey),
        //   label: '',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.search,
        //       size: 30,
        //       color: _selectedIndex == 1 ? Colors.black : Colors.grey),
        //   label: '',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill,
              size: 30,
              color: _selectedIndex == 2 ? Colors.black : Colors.grey),
          label: '',
        ),
        // BottomNavigationBarItem(
        //   icon: Container(
        //     padding: EdgeInsets.all(0),
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       gradient: LinearGradient(
        //         colors: [Colors.redAccent, Colors.orangeAccent],
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //       ),
        //     ),
        //     child: Icon(Icons.play_circle_fill, size: 30, color: Colors.white),
        //   ),
        //   label: '',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.notifications,
        //       size: 30,
        //       color: _selectedIndex == 3 ? Colors.black : Colors.grey),
        //   label: '',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person,
              size: 30,
              color: _selectedIndex == 4 ? Colors.black : Colors.grey),
          label: '',
        ),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 10,
    );
  }
}
