import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class JumbledPostAPI {
  int? id;
  String? content;
  String? mediaUrl;
  String? mediaType;
  int? userId;
  String? createdAt;
  String? updatedAt;
  User? user;
  String? profilePic;
  String? username;
  String? thumbNail;

  JumbledPostAPI(
      {this.id,
      this.content,
      this.mediaUrl,
      this.mediaType,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.profilePic,
      this.username,
      this.thumbNail});

  JumbledPostAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    mediaUrl = json['mediaUrl'];
    mediaType = json['mediaType'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    profilePic = json['profilePic'];
    username = json['username'];
    thumbNail = json['thumbNail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['mediaUrl'] = this.mediaUrl;
    data['mediaType'] = this.mediaType;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['profilePic'] = this.profilePic;
    data['username'] = this.username;
    data['thumbNail'] = this.thumbNail;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    return data;
  }

  static Future<List<JumbledPostAPI>> profilepost() async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.jumbledPost}");

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final responseString = response.body;
      print(responseString);

      // Parse the response as a list of JSON objects
      List<dynamic> jsonResponse = jsonDecode(responseString);

      // Convert each JSON object into a JumbledPostAPI instance
      List<JumbledPostAPI> jumbledPosts =
          jsonResponse.map((json) => JumbledPostAPI.fromJson(json)).toList();

      return jumbledPosts;
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? password;
  String? bio;
  String? profilePic;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.bio,
      this.profilePic,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    bio = json['bio'];
    profilePic = json['profilePic'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['bio'] = this.bio;
    data['profilePic'] = this.profilePic;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
