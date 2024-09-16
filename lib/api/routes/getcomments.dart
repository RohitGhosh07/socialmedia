import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kkh_events/api/webservices.dart';

import 'package:kkh_events/api/class/User.dart';

class GetCommentAPI {
  int? id;
  int? userId;
  int? postId;
  String? text;
  String? createdAt;
  String? updatedAt;
  User? user;

  GetCommentAPI(
      {this.id,
      this.userId,
      this.postId,
      this.text,
      this.createdAt,
      this.updatedAt,
      this.user});

  GetCommentAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postId = json['postId'];
    text = json['text'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['postId'] = this.postId;
    data['text'] = this.text;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  // Updated method to handle a list of chats
  static Future<List<GetCommentAPI>> commentlist(int postId) async {
    final Uri url = Uri.parse(
        "${Webservice.rootURL}/${Webservice.getcomments}/${postId}"); // Update with your actual URL

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Map each item in the list to a ChatIdAPI object
        return responseData
            .map((chatData) => GetCommentAPI.fromJson(chatData))
            .toList();
      } else {
        // Handle other status codes here
        throw Exception('Failed to load chat list');
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }
}
