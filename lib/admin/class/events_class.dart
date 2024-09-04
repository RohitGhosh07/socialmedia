import 'package:get/get.dart';
import 'package:kkh_events/admin/api_url.dart';
import 'package:kkh_events/admin/connection.dart';

class EventsClass {
  // "id": 14,
  //       "imgUrl": "http://salesmpower.acedns.in/kkh_events/images/IMG_9090.jpeg",
  //       "name": "Book Discussion ",
  //       "area": "Event",
  //       "club": "The Saturday Club",
  //       "dateAdded": "2024-08-23 09:31:41",
  //       "dateModified": null,
  //       "startDate": null,
  //       "endDate": null
  int? id;
  String? imgUrl;
  String? name;
  String? area;
  String? club;
  String? dateAdded;
  String? dateModified;
  String? startDate;
  String? endDate;

  EventsClass(
      {this.id,
      this.imgUrl,
      this.name,
      this.area,
      this.club,
      this.dateAdded,
      this.dateModified,
      this.startDate,
      this.endDate});

  EventsClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgUrl = json['imgUrl'];
    name = json['name'];
    area = json['area'];
    club = json['club'];
    dateAdded = json['dateAdded'];
    dateModified = json['dateModified'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    data['name'] = name;
    data['area'] = area;
    data['club'] = club;
    data['dateAdded'] = dateAdded;
    data['dateModified'] = dateModified;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }

  static Future<List<EventsClass>> getEvents({String? search}) async {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    String url = ApiUrl.eventsApi;
    if (search != null) {
      url = "$url?search=$search";
    }
    final response = await DioClient().get(url);
    Get.back();
    if (response != null && response.statusCode == 200) {
      List<EventsClass> events = [];
      for (var item in response.data) {
        events.add(EventsClass.fromJson(item));
      }
      return events;
    }
    return [];
  }

  static Future<List<EventsClass>> getEventsbyDate(String date) async {
    String url = "${ApiUrl.eventsApi}?action=filterbyDate$date";
    final response = await DioClient().get(url);
    if (response != null && response.statusCode == 200) {
      List<EventsClass> events = [];
      for (var item in response.data) {
        events.add(EventsClass.fromJson(item));
      }
      return events;
    }
    return [];
  }

  static Future<EventsClass?> getEventById(int id) async {
    final response = await DioClient().get("${ApiUrl.eventsApi}?id=$id");
    if (response != null && response.statusCode == 200) {
      return EventsClass.fromJson(response.data[0]);
    }
    return null;
  }

  static Future<bool> addEvent(EventsClass event) async {
    final response =
        await DioClient().post(ApiUrl.eventsApi, event.toJson(), null);
    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> updateEvent(EventsClass event) async {
    final response =
        await DioClient().post(ApiUrl.eventsApi, event.toJson(), null);
    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> deleteEvent(int id) async {
    String url = "${ApiUrl.eventsApi}?id=$id&action=delete";
    final response = await DioClient().get(url);
    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
