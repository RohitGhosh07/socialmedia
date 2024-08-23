import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:swipecv/models/image_model.dart';
import 'package:swipecv/screens/components/FilterPopup.dart';
import 'package:swipecv/screens/components/ZoomView.dart';
import '../providers/image_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _scrollController = PageController();
  bool _showButtons = false;
  ValueNotifier<double> scaleNotifier = ValueNotifier<double>(1.0);
  final TextEditingController _searchController = TextEditingController();
  bool _isExpanded = false;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppImageProvider>(context, listen: false).loadImages();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showButtons) {
          setState(() {
            _showButtons = true;
            _isExpanded = false;
          });
        }
      } else {
        if (_showButtons) {
          setState(() {
            _showButtons = false;
            _isExpanded = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ImageModel> images = Provider.of<AppImageProvider>(context).images;
    String selectedArea = Provider.of<AppImageProvider>(context).selectedArea;
    String selectedClub = Provider.of<AppImageProvider>(context).selectedClub;
    final isLoading = Provider.of<AppImageProvider>(context).isLoading;

    if (selectedArea.isNotEmpty) {
      images = images.where((e) => e.area == selectedArea).toList();
    }
    if (selectedClub.isNotEmpty) {
      images = images.where((e) => e.club == selectedClub).toList();
    }

    return Scaffold(
      body: Stack(
        children: [
          if (images.isNotEmpty && !isLoading)
            PageView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onDoubleTap: () {
                    // Navigate to ZoomView
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ZoomView(
                          images: images[index],
                        );
                      }),
                    );
                  },
                  onTap: () {
                    // Navigate to ZoomView
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ZoomView(
                          images: images[index],
                        );
                      }),
                    );
                  },
                  child: Image.network(
                    images[index].imgUrl ?? '',
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context)
                        .size
                        .width, // To make sure the image fits the width of the screen
                  ),
                );
              },
            ),
          if (images.isEmpty && !isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 50),
                  Text('No CV found'),
                ],
              ),
            ),
          if (_showButtons || images.isEmpty)
            Positioned(
              // at the top center
              top: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Modern Search Bar
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.indigo[100]!
                          ], // Adjust the gradient colors as needed
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(
                                0.3), // Adjust shadow opacity and blur
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search,
                                size: 24,
                                color:
                                    Colors.white), // Adjust icon size and color
                            onPressed: () {
                              // Trigger search or any other action
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search Name',
                                hintStyle: TextStyle(
                                    color:
                                        Colors.white), // Adjust hint text style
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal:
                                        16), // Adjust padding for better alignment
                              ),
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                                Provider.of<AppImageProvider>(context,
                                            listen: false)
                                        .searchValue =
                                    _searchController.text.trim();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Modern Filter Button
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => FilterPopup(),
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // Fixed black overlay container at the bottom
          if (images.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Toggle expanded state
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.7)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  height: _isExpanded ? 220 : 80,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Text(
                          images.isNotEmpty
                              ? images[_currentIndex].name ?? 'Unknown Name'
                              : 'No Name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height:
                                1.5, // Improved line height for better readability
                          ),
                          maxLines: _isExpanded ? null : 2,
                          overflow: _isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                      ),
                      if (!_isExpanded)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: const Text(
                              'See More',
                              style: TextStyle(
                                color: Colors.grey, // Text color
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
