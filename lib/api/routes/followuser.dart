import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class FollowUserAPI {
  String? message;
  String? action;

  FollowUserAPI({this.message, this.action});

  FollowUserAPI.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['action'] = this.action;
    return data;
  }

  static Future<FollowUserAPI> followuser(
    int followerId,
    int followingId,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.toggleFollowUser}");

    Map<String, String> body = {
      'followerId': "$followerId",
      'followingId': "$followingId",
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseString = response.body;

      FollowUserAPI followuser =
          FollowUserAPI.fromJson(jsonDecode(responseString));

      return followuser;
    } catch (e) {
      print("Error from api: $e");
      throw e;
    }
  }
}
