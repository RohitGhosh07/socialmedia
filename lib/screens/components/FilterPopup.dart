import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipecv/providers/image_provider.dart';

class FilterPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<AppImageProvider>(context);
    String selectedArea = imageProvider.selectedArea;
    String selectedClub = imageProvider.selectedClub;

    List<String> areas = imageProvider.images
        .where((element) {
          if (selectedClub.isNotEmpty) {
            return element.club == selectedClub;
          } else {
            return true;
          }
        })
        .map((e) => e.area ?? '')
        .toSet()
        .toList();
    List<String> clubs = imageProvider.images
        .where((element) {
          if (selectedArea.isNotEmpty) {
            return element.area == selectedArea;
          } else {
            return true;
          }
        })
        .map((e) => e.club ?? '')
        .toSet()
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 4.0,
                          color: Colors.blueAccent,
                        ),
                        insets: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      labelColor: Colors.blueAccent,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Type'),
                        Tab(text: 'Club'),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        children: [
                          ListView.builder(
                            itemCount: areas.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  areas[index],
                                  style: TextStyle(
                                    fontStyle: areas[index] == selectedArea
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    fontWeight: areas[index] == selectedArea
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: areas[index] == selectedArea
                                        ? Colors.blueAccent
                                        : Colors.black87,
                                  ),
                                ),
                                onTap: () {
                                  imageProvider.selectedArea = areas[index];
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: clubs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  clubs[index],
                                  style: TextStyle(
                                    fontStyle: clubs[index] == selectedClub
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    fontWeight: selectedClub == clubs[index]
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: selectedClub == clubs[index]
                                        ? Colors.blueAccent
                                        : Colors.black87,
                                  ),
                                ),
                                onTap: () {
                                  imageProvider.selectedClub = clubs[index];
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  imageProvider.selectedArea = '';
                  imageProvider.selectedClub = '';
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
