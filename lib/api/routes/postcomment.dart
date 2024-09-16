import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class PostCommentAPI {
  int? id;
  int? userId;
  int? postId;
  String? text;
  String? updatedAt;
  String? createdAt;

  PostCommentAPI(
      {this.id,
      this.userId,
      this.postId,
      this.text,
      this.updatedAt,
      this.createdAt});

  PostCommentAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    postId = json['postId'];
    text = json['text'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['postId'] = this.postId;
    data['text'] = this.text;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }

  static Future<PostCommentAPI> postcomment(
    int userId,
    int postId,
    String text,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.postcomments}");

    Map<String, String> body = {
      'userId': "$userId",
      'postId': "$postId",
      'text': "$text",
    };
    print("body: $body");
    print("url: $url");
    print("userId: $userId");
    print("postId: $postId");
    print("text: $text");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseString = response.body;

      PostCommentAPI postcomment =
          PostCommentAPI.fromJson(jsonDecode(responseString));
      print("like: $postcomment");
      return postcomment;
    } catch (e) {
      print("Error from api: $e");
      throw e;
    }
  }
}
