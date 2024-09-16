import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

import 'package:kkh_events/api/class/User.dart';

class ProfilePostAPI {
  ProfileUser? user;
  List<Posts>? posts;

  ProfilePostAPI({this.user, this.posts});

  ProfilePostAPI.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new ProfileUser.fromJson(json['user']) : null;
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(new Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<ProfilePostAPI> profilepost(
    int id,
  ) async {
    Uri url =
        Uri.parse("${Webservice.rootURL}/${Webservice.profilePost}/${id}");

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final responseString = response.body;
      print(responseString);

      ProfilePostAPI profilepost =
          ProfilePostAPI.fromJson(jsonDecode(responseString));

      return profilepost;
    } catch (e) {
      print("Error from api: $e");
      throw e;
    }
  }
}

class ProfileUser {
  int? id;
  String? username;
  String? email;
  String? bio;
  String? profilePic;
  int? postCount;

  ProfileUser(
      {this.id,
      this.username,
      this.email,
      this.bio,
      this.profilePic,
      this.postCount});

  ProfileUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    bio = json['bio'];
    profilePic = json['profilePic'];
    postCount = json['postCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['bio'] = bio;
    data['profilePic'] = profilePic;
    data['postCount'] = postCount;
    return data;
  }
}

class Posts {
  int? id;
  String? content;
  String? mediaUrl;
  String? mediaType;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? profilePic;
  String? username;
  String? thumbNail;
  String? likeCount;
  User? user;

  Posts(
      {this.id,
      this.content,
      this.mediaUrl,
      this.mediaType,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.profilePic,
      this.username,
      this.thumbNail,
      this.likeCount,
      this.user});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    mediaUrl = json['mediaUrl'];
    mediaType = json['mediaType'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profilePic = json['profilePic'];
    username = json['username'];
    thumbNail = json['thumbNail'];
    likeCount = json['likeCount'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['mediaUrl'] = mediaUrl;
    data['mediaType'] = mediaType;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['profilePic'] = profilePic;
    data['username'] = username;
    data['thumbNail'] = thumbNail;
    data['likeCount'] = likeCount;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    return data;
  }
}
