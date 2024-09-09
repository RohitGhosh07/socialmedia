import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

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
    int id,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.profile}");

    Map<String, String> body = {
      'id': "${id}",
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseString = response.body;
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

class User {
  int? id;
  String? username;
  String? email;
  String? bio;
  String? profilePic;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.bio,
      this.profilePic,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    bio = json['bio'];
    profilePic = json['profilePic'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['bio'] = bio;
    data['profilePic'] = profilePic;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
