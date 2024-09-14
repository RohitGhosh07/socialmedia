import 'package:http/http.dart' as http;
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

import 'package:kkh_events/api/class/User.dart';

class FollowingPostAPI {
  int? id;
  String? content;
  String? mediaUrl;
  String? createdAt;
  int? userId;
  String? username;
  String? profilePic;

  FollowingPostAPI(
      {this.id,
      this.content,
      this.mediaUrl,
      this.createdAt,
      this.userId,
      this.username,
      this.profilePic});

  FollowingPostAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    mediaUrl = json['mediaUrl'];
    createdAt = json['createdAt'];
    userId = json['userId'];
    username = json['username'];
    profilePic = json['profilePic'];
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
        print(responseList);
        print(userId);
        print(postList);
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
