import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kkh_events/admin/class/clubs_class.dart';
import 'package:kkh_events/admin/class/events_class.dart';
import 'package:kkh_events/admin/class/login_api_class.dart';
import 'package:kkh_events/admin/class/types_class.dart';
import 'package:kkh_events/admin/custom_widgets.dart';
import 'package:kkh_events/admin/routes/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<EventsClass>> eventsList;
  TextEditingController searchController = TextEditingController();
  String selctedFilter = 'Club';
  String? selectedClub;
  String? selectedType;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    eventsList = EventsClass.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KKH Admin Panel'),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.addEditEvent)?.then((value) {
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                eventsList = EventsClass.getEvents();
              });
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<EventsClass>>(
                future: eventsList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.hasData) {
                      // close all dialogs
                      Get.isDialogOpen ?? false ? Get.back() : null;
                      List<EventsClass>? events = snapshot.data;
                      return Column(
                        children: [
                          // Filter
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search by club, description',
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                    onSubmitted: (value) {
                                      setState(() {
                                        eventsList = EventsClass.getEvents(
                                            search: value);
                                      });
                                    },
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          eventsList = EventsClass.getEvents();
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    // show popup
                                    filters();
                                  },
                                  child: const Text('Filter'),
                                ),
                              ],
                            ),
                          ),
                          events?.isEmpty ?? true
                              ? const Center(
                                  child: Text('No events found'),
                                )
                              :
                              // List of Events
                              Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: events?.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: InkWell(
                                          onTap: () => showEventDetails(
                                              events?[index] ?? EventsClass()),
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        events?[index].area ??
                                                            '',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300)),
                                                    const Spacer(),
                                                    Text(
                                                      "Added: ${events?[index].dateAdded == null ? "N/A" : DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(events?[index].dateAdded ?? ''))}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              events?[index]
                                                                      .imgUrl ??
                                                                  ''),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(events?[index]
                                                                .club ??
                                                            ''),
                                                        Text(
                                                          events?[index].name ??
                                                              '',
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        // Three dots
                                                        IconButton(
                                                          onPressed: () {
                                                            // show bottom sheet
                                                            Get.bottomSheet(
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                        Get.toNamed(
                                                                            Routes.addEditEvent,
                                                                            arguments: {
                                                                              'event': events?[index],
                                                                              'isEdit': true
                                                                            })?.then(
                                                                            (value) {
                                                                          Future.delayed(
                                                                              const Duration(seconds: 2),
                                                                              () {
                                                                            setState(() {
                                                                              eventsList = EventsClass.getEvents();
                                                                            });
                                                                          });
                                                                        });
                                                                      },
                                                                      child: const Text(
                                                                          'Edit',
                                                                          style:
                                                                              TextStyle(color: Colors.blue)),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              title: const Text('Delete Event'),
                                                                              content: const Text('Are you sure you want to delete this event?'),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                    CustomWidgets.showLoadingLoader();
                                                                                    EventsClass.deleteEvent(events?[index].id ?? 0).then((value) {
                                                                                      Get.back();
                                                                                      if (value) {
                                                                                        CustomWidgets.errorSnackBar(content: 'Event deleted successfully');
                                                                                        setState(() {
                                                                                          eventsList = EventsClass.getEvents();
                                                                                        });
                                                                                      } else {
                                                                                        CustomWidgets.errorSnackBar(content: 'Error deleting event');
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: const Text(
                                                                          'Delete',
                                                                          style:
                                                                              TextStyle(color: Colors.red)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                              Icons.more_vert),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('No events found'),
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }

  void logout() {
    // clear data from get storage
    LoginApiClass.clearData();
    // navigate to login screen
    Get.offAllNamed(Routes.login);
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

  void showEventDetails(EventsClass event) {
    Get.dialog(
      AlertDialog(
        title: Text(event.area ?? ''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(event.imgUrl ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Club
            Text('Club: ${event.club ?? ''}'),
            const SizedBox(height: 10),
            // Added Date
            Text(
                'Added: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(event.dateAdded ?? ''))}'),
            const SizedBox(height: 10),
            // Description
            Text('Description: ${event.name ?? ''}'),
            const SizedBox(height: 10),
            // Start Date
            if (event.area == 'Event')
              Text(
                  'Event Date: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(event.startDate ?? ''))}'),
            if (event.area == 'Offer')
              Text(
                  'Offer Start Date: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(event.startDate ?? ''))}'),
            if (event.area == 'News')
              Text(
                  'News Date: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(event.startDate ?? ''))}'),
            const SizedBox(height: 10),
            // End Date
            if (event.area == 'Offer')
              Text('Offer End Date: ${event.endDate ?? ''}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
