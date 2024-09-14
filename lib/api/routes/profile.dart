import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

import 'package:kkh_events/api/class/User.dart';

class ProfileAPI {
  User? user;
  String? message;

  ProfileAPI({this.user, this.message});

  ProfileAPI.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['message'] = message;
    return data;
  }

  static Future<ProfileAPI> profile(
    int profileId,
    int userId,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.profile}");

    Map<String, String> body = {
      'profileId': "$profileId",
      'userId': "$userId",
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseString = response.body;
      print(profileId);
      print(userId);
      print(responseString);

      ProfileAPI loginResponse =
          ProfileAPI.fromJson(jsonDecode(responseString));

      return loginResponse;
    } catch (e) {
      print("Error from api: $e");
      throw e;
    }
  }
}
