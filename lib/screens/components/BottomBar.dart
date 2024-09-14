import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final String profilePic;

  const BottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.profilePic,
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
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled,
              size: 30,
              color: _selectedIndex == 0 ? Colors.black : Colors.grey),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search,
              size: 30,
              color: _selectedIndex == 1 ? Colors.black : Colors.grey),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add,
              size: 30,
              color: _selectedIndex == 2 ? Colors.black : Colors.grey),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow,
              size: 30,
              color: _selectedIndex == 3 ? Colors.black : Colors.grey),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              CircleAvatar(
                radius: 14, // Adjust as needed
                backgroundImage: NetworkImage(widget.profilePic),
                backgroundColor: Colors
                    .transparent, // Optional: Set background color if needed
              ),
              // Border container
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50, // Adjust as needed
                    height: 50, // Adjust as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedIndex == 4
                            ? Colors.black.withOpacity(0.5)
                            : Colors.transparent, // Border color
                        width: 2, // Border width
                      ),
                    ),
                  ),
                ),
              ),
              // CircleAvatar
            ],
          ),
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
