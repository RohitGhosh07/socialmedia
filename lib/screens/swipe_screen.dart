import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';
import 'package:kkh_events/models/image_model.dart';
import 'package:kkh_events/screens/components/ZoomView.dart';
import 'package:shimmer/shimmer.dart';
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
  String selctedFilter = 'Club';
  String? selectedClub;
  String? selectedType;
  DateTime? startDate;
  DateTime? endDate;

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
                return Stack(
                  children: [
                    // Full-screen image
                    GestureDetector(
                      onDoubleTap: () {
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
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Image is fully loaded
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Icon(Icons.error)); // Handle error
                        },
                      ),
                    ),
                    // Black overlay with opacity
                    Container(
                      color:
                          Colors.black.withOpacity(0.2), // Adjust opacity here
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    // Fixed avatar and text at top left of the image
                    Positioned(
                      bottom: 10,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.orangeAccent,
                                      Colors.pinkAccent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                    images.isNotEmpty
                                        ? images[_currentIndex].imgUrl ?? ''
                                        : '',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    images.isNotEmpty
                                        ? images[_currentIndex].club ??
                                            'Unknown Club'
                                        : 'No Club',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    images.isNotEmpty
                                        ? images[_currentIndex].area ??
                                            'Unknown Area'
                                        : 'No Area',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              // OutlinedButton(
                              //   onPressed: () {
                              //     // Implement the follow action
                              //   },
                              //   style: OutlinedButton.styleFrom(
                              //     side: const BorderSide(
                              //         color: Colors.white), // White border
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(
                              //           20), // Rounded corners
                              //     ),
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 20,
                              //         vertical: 0), // Padding inside the button
                              //     backgroundColor: Colors
                              //         .transparent, // Transparent background
                              //   ),
                              //   child: const Text(
                              //     'Follow',
                              //     style: TextStyle(
                              //         color: Colors.white), // White text
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      images.isNotEmpty
                                          ? images[_currentIndex].name ??
                                              'Unknown Name'
                                          : 'No Name',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                      maxLines: _isExpanded ? null : 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (!_isExpanded)
                                      const Text(
                                        '...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          if (images.isEmpty && !isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 50),
                  Text('No Events found'),
                ],
              ),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      // bottomNavigationBar: BottomBar(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
