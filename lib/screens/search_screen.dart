import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kkh_events/providers/image_provider.dart';
import 'package:kkh_events/screens/swipe_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load initial images
    Provider.of<AppImageProvider>(context, listen: false).loadImages();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<AppImageProvider>(context);
    final images = imageProvider.images;
    final isLoading = imageProvider.isLoading;

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
              // Update search query in the provider
              imageProvider.searchValue = value;
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
                crossAxisCount: 3, // 3 columns like Instagram
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 1.0, // Square items
              ),
              itemCount: 66, // Show 9 shimmer tiles (3x3 grid)
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
          : GridView.builder(
              padding: const EdgeInsets.all(2.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns like Instagram
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 1.0, // Square items
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainScreen()), // Replace MainScreen with your screen's name
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            image.imgUrl ?? 'assets/images/KKH Events.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
