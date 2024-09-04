import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kkh_events/admin/class/clubs_class.dart';
import 'package:kkh_events/admin/class/events_class.dart';
import 'package:kkh_events/admin/class/types_class.dart';
import 'package:provider/provider.dart';
import 'package:kkh_events/models/image_model.dart';
import 'package:kkh_events/screens/components/FilterPopup.dart';
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
  late Future<List<EventsClass>> eventsList;

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
          if (_showButtons || images.isEmpty)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Modern Search Bar
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blueGrey, Colors.grey],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
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
                                    size: 24, color: Colors.white),
                                onPressed: () {
                                  // Trigger search or any other action
                                },
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Search Name',
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
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
                        // onTap: () => showDialog(
                        //   context: context,
                        //   builder: (context) => FilterPopup(),
                        // ),
                        onTap: () async {
                          filters();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.grey, Colors.blueGrey],
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
                ],
              ),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // // Fixed black overlay container at the bottom
          // if (images.isNotEmpty)
          //   Positioned(
          //     bottom: 50,
          //     left: 20,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             Container(
          //               decoration: BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 gradient: const LinearGradient(
          //                   colors: [
          //                     Colors.orangeAccent,
          //                     Colors.pinkAccent,
          //                   ],
          //                   begin: Alignment.topLeft,
          //                   end: Alignment.bottomRight,
          //                 ),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.black.withOpacity(0.15),
          //                     blurRadius: 10,
          //                     offset: const Offset(0, 5),
          //                   ),
          //                 ],
          //               ),
          //               child: CircleAvatar(
          //                 radius: 24,
          //                 backgroundImage: NetworkImage(
          //                   images.isNotEmpty
          //                       ? images[_currentIndex].imgUrl ?? ''
          //                       : '',
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(width: 16),
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   images.isNotEmpty
          //                       ? images[_currentIndex].club ?? 'Unknown Club'
          //                       : 'No Club',
          //                   style: TextStyle(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //                 Text(
          //                   images.isNotEmpty
          //                       ? images[_currentIndex].area ?? 'Unknown Area'
          //                       : 'No Area',
          //                   style: TextStyle(
          //                     fontSize: 12,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 10),
          //         AnimatedContainer(
          //           duration: const Duration(milliseconds: 300),
          //           constraints: BoxConstraints(
          //             maxHeight: _isExpanded ? double.infinity : 50,
          //           ),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 images.isNotEmpty
          //                     ? images[_currentIndex].name ?? 'Unknown Name'
          //                     : 'No Name',
          //                 style: const TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w600,
          //                   height: 1.5,
          //                 ),
          //                 maxLines: _isExpanded ? null : 1,
          //                 overflow: _isExpanded
          //                     ? TextOverflow.visible
          //                     : TextOverflow.ellipsis,
          //               ),
          //               if (!_isExpanded)
          //                 GestureDetector(
          //                   onTap: () {
          //                     setState(() {
          //                       _isExpanded = true;
          //                     });
          //                   },
          //                   child: Text(
          //                     '... See More',
          //                     style: const TextStyle(
          //                       color: Colors.grey,
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                 ),
          //               if (_isExpanded)
          //                 GestureDetector(
          //                   onTap: () {
          //                     setState(() {
          //                       _isExpanded = false;
          //                     });
          //                   },
          //                   child: Text(
          //                     'See Less',
          //                     style: const TextStyle(
          //                       color: Colors.grey,
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                 ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   )
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

  void filters() async {
    await Get.dialog(
      SimpleDialog(
        title: Row(
          children: [
            const Text('Filter Events'),
            const Spacer(),
            // Reset button
            TextButton(
              onPressed: () {
                Get.back();
                setState(() {
                  eventsList = EventsClass.getEvents();
                  selectedClub = null;
                  selectedType = null;
                  startDate = null;
                  endDate = null;
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        children: [
          // (Dropdown) Filter by: Club, Type, Date
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Filter by: '),
                const Spacer(),
                DropdownButton<String>(
                  value: selctedFilter,
                  items: const [
                    DropdownMenuItem(
                      value: 'Club',
                      child: Text('Club'),
                    ),
                    DropdownMenuItem(
                      value: 'Type',
                      child: Text('Type'),
                    ),
                    DropdownMenuItem(
                      value: 'Date',
                      child: Text('Date'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selctedFilter = value!;
                    });
                    Future.delayed(const Duration(milliseconds: 100), () {
                      filters();
                    });
                  },
                ),
              ],
            ),
          ),
          selctedFilter == 'Type'
              ? filterByType()
              : selctedFilter == 'Club'
                  ? filterByClub()
                  : filterbyDate(),
        ],
      ),
    );
  }

  Widget filterByClub() {
    return FutureBuilder(
        future: ClubsClass.getClubs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading clubs'),
              );
            } else {
              List<ClubsClass>? clubs = snapshot.data;
              return Column(
                children: [
                  ...?clubs?.map((e) {
                    return ListTile(
                      title: Text(e.club ?? '',
                          style: TextStyle(
                              color: e.club == selectedClub
                                  ? Colors.blue
                                  : Colors.black)),
                      onTap: () {
                        Get.back();
                        setState(() {
                          eventsList = EventsClass.getEvents(search: e.club);
                          selectedClub = e.club;
                          selectedType = null;
                        });
                      },
                    );
                  })
                ],
              );
            }
          }
        });
  }

  Widget filterByType() {
    return FutureBuilder(
        future: TypesClass.getTypes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading types'),
              );
            } else {
              List<TypesClass>? types = snapshot.data;
              return Column(
                children: [
                  ...?types?.map((e) {
                    return ListTile(
                      title: Text(e.area ?? '',
                          style: TextStyle(
                              color: e.area == selectedType
                                  ? Colors.blue
                                  : Colors.black)),
                      onTap: () {
                        Get.back();
                        setState(() {
                          eventsList = EventsClass.getEvents(search: e.area);
                          selectedType = e.area;
                          selectedClub = null;
                        });
                      },
                    );
                  })
                ],
              );
            }
          }
        });
  }

  Widget filterbyDate() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Date Picker
          Row(
            children: [
              const Text('From: '),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // show date picker
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  ).then((value) {
                    if (value != null) {
                      // set date
                      // filter events
                      setState(() {
                        startDate = value;
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        filters();
                      });
                    }
                  });
                },
                child: startDate == null
                    ? const Text('Select Date')
                    : Text(DateFormat('dd/MM/yyyy').format(startDate!)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('To: '),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // show date picker
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  ).then((value) {
                    if (value != null) {
                      // set date
                      // filter events
                      setState(() {
                        endDate = value;
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        filters();
                      });
                    }
                  });
                },
                child: endDate == null
                    ? const Text('Select Date')
                    : Text(DateFormat('dd/MM/yyyy')
                        .format(endDate ?? DateTime.now())),
              ),
            ],
          ),
          const SizedBox(height: 10),
          (startDate == null || endDate == null)
              ? const SizedBox()
              : ElevatedButton(
                  onPressed: () {
                    Get.back();
                    setState(() {
                      eventsList = EventsClass.getEventsbyDate(
                          '&start_date=${DateFormat('yyyy-MM-dd').format(startDate ?? DateTime.now())}&end_date=${DateFormat('yyyy-MM-dd').format(endDate ?? DateTime.now())}');
                    });
                  },
                  child: const Text('Filter'),
                ),
        ],
      ),
    );
  }
}
