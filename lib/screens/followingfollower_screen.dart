import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/routes/follower.dart';
import 'package:kkh_events/api/routes/following.dart';
import 'package:kkh_events/screens/profile_screen.dart';

class FollowingFollowerScreen extends StatefulWidget {
  final List<Followers> followerList;
  final List<Following> followingList;

  FollowingFollowerScreen(
      {required this.followerList, required this.followingList});

  @override
  _FollowingFollowerScreenState createState() =>
      _FollowingFollowerScreenState();
}

class _FollowingFollowerScreenState extends State<FollowingFollowerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? mainuserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserId();
  }

// Async function to fetch user ID and handle Future properly
  Future<void> _fetchUserId() async {
    UserProvider userProvider = UserProvider();
    int? fetchedUserId = await userProvider.userId; // Await the Future
    setState(() {
      mainuserId = fetchedUserId; // Update the state with the fetched user ID
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              child: Text('Following', style: TextStyle(fontSize: 16)),
            ),
            Tab(
              child: Text('Followers', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Following List
          _buildFollowingList(),
          // Followers List
          _buildFollowerList(),
        ],
      ),
    );
  }

  // Widget to build the "Following" list
  Widget _buildFollowingList() {
    return widget.followingList.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: widget.followingList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userId: widget.followingList[index].id ?? 0,
                        mainuserId: mainuserId!,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Image.network(
                    '${widget.followingList[index].profilePic ?? ''}',
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(widget.followingList[index].username ?? ''),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Handle Unfollow button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child:
                      Text('Following', style: TextStyle(color: Colors.white)),
                ),
              );
            },
          )
        : Center(child: Text('No Following users'));
  }

  // Widget to build the "Followers" list
  Widget _buildFollowerList() {
    return widget.followerList.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: widget.followerList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userId: widget.followerList[index].id ?? 0,
                        mainuserId: mainuserId,
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Image.network(
                    '${widget.followerList[index].profilePic ?? ''}',
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(widget.followerList[index].username ?? ''),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Handle Follow Back button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Follow Back',
                      style: TextStyle(color: Colors.white)),
                ),
              );
            },
          )
        : Center(child: Text('No Followers'));
  }
}
