import 'package:http/http.dart' as http;
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

import 'package:kkh_events/api/class/User.dart';

class FollowingPostAPI {
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

  FollowingPostAPI(
      {this.id,
      this.content,
      this.mediaUrl,
      this.createdAt,
      this.userId,
      this.username,
      this.profilePic,
      this.thumbNail,
      this.likeCount,
      this.user});

  FollowingPostAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    mediaUrl = json['mediaUrl'];
    createdAt = json['createdAt'];
    userId = json['userId'];
    username = json['username'];
    profilePic = json['profilePic'];
    thumbNail = json['thumbNail'];
    likeCount = json['likeCount'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['mediaUrl'] = this.mediaUrl;
    data['createdAt'] = this.createdAt;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['profilePic'] = this.profilePic;
    data['thumbNail'] = this.thumbNail;
    data['likeCount'] = this.likeCount;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    return data;
  }

  Future<List<FollowingPostAPI>> postlist(int userId) async {
    // int? userId;
    try {
      final Uri url = Uri.parse(
        "${Webservice.rootURL}/${Webservice.followingpost}/${userId}",
      );

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseList = jsonDecode(response.body);

        // Map the responseList to a List of FollowingPostAPI objects
        List<FollowingPostAPI> postList = responseList.map((postJson) {
          return FollowingPostAPI.fromJson(postJson);
        }).toList();
        // print(responseList);
        print(userId);
        // print(postList);
        return postList; // Return the list of posts
      } else {
        // Handle other status codes here
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}
