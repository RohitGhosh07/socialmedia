import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class LikeAPI {
  NewLike? newLike;
  String? message;

  LikeAPI({this.newLike, this.message});

  LikeAPI.fromJson(Map<String, dynamic> json) {
    newLike =
        json['newLike'] != null ? new NewLike.fromJson(json['newLike']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newLike != null) {
      data['newLike'] = this.newLike!.toJson();
    }
    data['message'] = this.message;
    return data;
  }

  static Future<LikeAPI> liking(
    int userId,
    int postId,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.togglelikes}");

    Map<String, String> body = {
      'userId': "$userId",
      'postId': "$postId",
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseString = response.body;

      LikeAPI like = LikeAPI.fromJson(jsonDecode(responseString));
      print("like: $like");
      return like;
    } catch (e) {
      print("Error from api: $e");
      throw e;
    }
  }
}

class NewLike {
  int? id;
  int? userId;
  int? postId;
  String? updatedAt;
  String? createdAt;

  NewLike({this.id, this.userId, this.postId, this.updatedAt, this.createdAt});

  NewLike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postId = json['postId'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['postId'] = this.postId;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
