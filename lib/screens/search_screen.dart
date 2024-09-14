import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/routes/jumbledPost.dart';
import 'package:kkh_events/api/routes/profilesearch.dart';
import 'package:kkh_events/screens/PostScreen.dart';
import 'package:kkh_events/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<JumbledPostAPI> posts = [];
  List<Users> _searchResults = [];
  bool isLoading = true;
  int? mainuserId;

  @override
  void initState() {
    super.initState();
    fetchJumbledPosts();
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

  Future<void> fetchJumbledPosts() async {
    try {
      final List<JumbledPostAPI> fetchedPosts =
          await JumbledPostAPI.profilepost();
      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching posts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      isLoading = true;
    });

    if (query.isNotEmpty) {
      try {
        ProfileSearchAPI searchAPI = ProfileSearchAPI();
        ProfileSearchAPI result = await searchAPI.profilesearchresult(query);
        setState(() {
          _searchResults = result.users ?? [];
          isLoading = false;
        });
      } catch (e) {
        print("Search error: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        _searchResults = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40.0,
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _performSearch(value);
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            ),
          ),
        ),
      ),
      body: isLoading
          ? GridView.builder(
              padding: const EdgeInsets.all(2.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 1.0,
              ),
              itemCount: 66,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                  ),
                );
              },
            )
          : _searchResults.isEmpty
              ? GridView.builder(
                  padding: const EdgeInsets.all(2.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostflowScreen(
                              posts: posts,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: post.mediaType == 'video' &&
                                  post.thumbNail != null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      post.thumbNail!),
                                  fit: BoxFit.cover,
                                )
                              : post.mediaUrl != null
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          post.mediaUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                          gradient: post.mediaUrl == null
                              ? LinearGradient(
                                  colors: [
                                    Colors.grey[300]!,
                                    Colors.grey[400]!
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                        ),
                        child: post.mediaType == 'video'
                            ? Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.play_circle_fill,
                                    color: Colors.white54),
                              )
                            : post.mediaUrl == null
                                ? Icon(Icons.image, color: Colors.white54)
                                : null,
                      ),
                    );
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(2.0),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.profilePic != null
                            ? CachedNetworkImageProvider(user.profilePic!)
                            : null,
                        child:
                            user.profilePic == null ? Icon(Icons.person) : null,
                      ),
                      title: Text(user.username ?? 'Unknown'),
                      subtitle: Text(user.email ?? 'No email'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                userId: user.id, mainuserId: mainuserId),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
