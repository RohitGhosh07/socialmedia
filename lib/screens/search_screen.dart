import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kkh_events/models/image_model.dart';
import 'package:kkh_events/providers/image_provider.dart';
import 'package:kkh_events/screens/components/BottomBar.dart';
import 'package:kkh_events/screens/main_screen.dart';
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
        title: const Text('Explorer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 40.0, // Reduced height for a sleeker look
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
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: images.map((image) {
                          return StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount:
                                2, // Adjusted to a default aspect ratio
                            child: Stack(
                              children: [
                                GestureDetector(
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: NetworkImage(image.imgUrl ??
                                            'https://via.placeholder.com/150'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 8.0,
                                  bottom: 8.0,
                                  child: Text(
                                    image.name ?? 'No Name',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomBar(),
    );
  }
}
