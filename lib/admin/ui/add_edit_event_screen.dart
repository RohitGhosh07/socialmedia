import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:kkh_events/admin/api_url.dart';
import 'package:kkh_events/admin/class/clubs_class.dart';
import 'package:kkh_events/admin/class/events_class.dart';
import 'package:kkh_events/admin/class/types_class.dart';
import 'package:kkh_events/admin/connection.dart';
import 'package:kkh_events/admin/custom_widgets.dart';

class AddEditEventScreen extends StatefulWidget {
  const AddEditEventScreen({super.key});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  late dynamic initialData;
  EventsClass? event;
  bool? isEdit;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController clubController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  bool? showthumnail;
  TextEditingController typeController = TextEditingController();
  DateTime? startDateController;
  DateTime? endDateController;
  List<TypesClass> types = [];
  List<ClubsClass> clubs = [];
  XFile? image;

  Future<void> initializer() async {
    types = await TypesClass.getTypes();
    clubs = await ClubsClass.getClubs();
  }

  void typeInitiate() {
    List<String> typeList = types.map((e) => e.area ?? '').toList();
    if (typeList.contains('Offer')) {
      null;
    } else {
      types.add(TypesClass(area: 'Offer'));
    }
    if (typeList.contains('Event')) {
      null;
    } else {
      types.add(TypesClass(area: 'Event'));
    }
    if (typeList.contains('News')) {
      null;
    } else {
      types.add(TypesClass(area: 'News'));
    }
    if (typeController.text == '') {
      typeController.text = types[0].area ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    initialData = initializer();
    event = Get.arguments?['event'];
    isEdit = Get.arguments?['isEdit'];
    if (event != null) {
      descriptionController.text = event?.name ?? '';
      clubController.text = event?.club ?? '';
      typeController.text = event?.area ?? '';
      imageController.text = event?.imgUrl ?? '';
      startDateController = event?.startDate != null
          ? DateTime.parse(event?.startDate ?? '')
          : null;
      endDateController =
          event?.endDate != null ? DateTime.parse(event?.endDate ?? '') : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey, // Apply gradient background
          elevation: 0, // Remove shadow for a flatter design
          title: Text(
            (isEdit ?? false) ? 'Edit Event' : 'Add Event',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          centerTitle: true, // Center align the title
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: initialData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                typeInitiate();
                List<String> clubSuggestions =
                    clubs.map((e) => e.club ?? '').toList();
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      // height: 200,
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null, // Allows unlimited lines
                        keyboardType: TextInputType
                            .multiline, // Optimizes keyboard for multiline input
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return clubSuggestions;
                          }
                          return clubSuggestions.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          clubController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          textEditingController.text = clubController.text;
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              labelText: 'Club',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        value: typeController.text == ''
                            ? types[0].area
                            : typeController.text,
                        items: types
                            .map((e) => DropdownMenuItem(
                                  value: e.area,
                                  child: Text(e.area ?? ''),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            typeController.text = value.toString();
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              (typeController.text == 'Event')
                                  ? 'Event Date: '
                                  : (typeController.text == 'News')
                                      ? 'News Date: '
                                      : 'Offer Start Date: ',
                            ),
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
                                      startDateController = value;
                                    });
                                  }
                                });
                              },
                              child: startDateController == null
                                  ? const Text('Select Date')
                                  : Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(startDateController!),
                                    ),
                            ),
                          ],
                        )),
                    if (typeController.text == 'Offer')
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text('Offer End Date: '),
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
                                      endDateController = value;
                                    });
                                  }
                                });
                              },
                              child: endDateController == null
                                  ? const Text('Select Date')
                                  : Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(endDateController!),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (imageController.text != '')
                      Stack(
                        children: [
                          // Image or placeholder
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[
                                  200], // Background color for the container
                              child: imageController.text.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Upload Image From Below',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Image.network(
                                      imageController.text,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                          // Optional: Add a border or decoration
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 4,
                                width: 50,
                                color: Colors
                                    .blue, // Optional border at the bottom
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (image != null || showthumnail == false)
                      Image.file(
                        File(image?.path ?? ''),
                        height: 200,
                      ),
                    // Image Picker
                    ElevatedButton(
                      onPressed: () {
                        // Pick Image
                        ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              image = value;
                              showthumnail = false;
                              imageController.text = '';
                            });
                          }
                        });
                      },
                      child: const Text('Upload Image'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add or Edit Event
                        addEdit();
                      },
                      child:
                          Text((isEdit ?? false) ? 'Edit Event' : 'Add Event'),
                    ),
                  ],
                );
              }),
        ));
  }

  addEdit() async {
    String url = "${ApiUrl.eventsApi}?action=";
    // final response = await DioClient().get(url);
    if (isEdit ?? false) {
      url = "${url}edit&id=${event?.id}";
      Map<String, dynamic> data = {
        'name': descriptionController.text,
        'club': clubController.text,
        'area': typeController.text,
        'startDate': startDateController.toString() == 'null'
            ? null
            : startDateController.toString(),
        'endDate': endDateController.toString() == 'null'
            ? null
            : endDateController.toString(),
      };
      CustomWidgets.showLoadingLoader();

      final response = await DioClient()
          .post(url, data, image != null ? File(image?.path ?? '') : null);
      Get.back();
      if (response != null && response.statusCode == 200) {
        Get.back();
        // success
        CustomWidgets.successSnackBar(content: 'Event Edited Successfully');
      } else {
        // error
        CustomWidgets.errorSnackBar(content: 'Error Editing Event');
      }

      // Edit Event
    } else {
      // validate
      if (descriptionController.text == '' ||
          clubController.text == '' ||
          typeController.text == '' ||
          startDateController == null) {
        CustomWidgets.errorSnackBar(content: 'All Fields are Required');
        return;
      }
      if (image == null) {
        CustomWidgets.errorSnackBar(content: 'Image is Required');
        return;
      }
      // Add Event
      url = "${url}create";
      Map<String, dynamic> data = {
        'name': descriptionController.text,
        'club': clubController.text,
        'area': typeController.text,
        'startDate': startDateController.toString() == 'null'
            ? null
            : startDateController.toString(),
        'endDate': endDateController.toString() == 'null'
            ? null
            : endDateController.toString(),
      };
      CustomWidgets.showLoadingLoader();
      final response = await DioClient()
          .post(url, data, image != null ? File(image?.path ?? '') : null);
      Get.back();
      if (response != null && response.statusCode == 200) {
        Get.back();
        // success
        CustomWidgets.successSnackBar(content: 'Event Added Successfully');
      } else {
        // error
        CustomWidgets.errorSnackBar(content: 'Error Adding Event');
      }
    }
  }
}
