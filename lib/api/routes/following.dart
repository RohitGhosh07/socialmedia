import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class FollowingAPI {
  int? followingCount;
  List<Following>? following;

  FollowingAPI({this.followingCount, this.following});

  FollowingAPI.fromJson(Map<String, dynamic> json) {
    followingCount = json['followingCount'];
    if (json['following'] != null) {
      following = <Following>[];
      json['following'].forEach((v) {
        following!.add(new Following.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followingCount'] = this.followingCount;
    if (this.following != null) {
      data['following'] = this.following!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Future<FollowingAPI> followinglist(int id) async {
    final Uri url =
        Uri.parse("${Webservice.rootURL}/api/users/${id}/following");

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseString = response.body;
        print(responseString);

        FollowingAPI followinglist =
            FollowingAPI.fromJson(jsonDecode(responseString));
        return followinglist;
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

class Following {
  int? id;
  String? username;
  String? email;
  Follows? follows;
  String? profilePic;

  Following(
      {this.id, this.username, this.email, this.follows, this.profilePic});

  Following.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profilePic = json['profilePic'];
    follows =
        json['Follows'] != null ? new Follows.fromJson(json['Follows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['profilePic'] = this.profilePic;
    if (this.follows != null) {
      data['Follows'] = this.follows!.toJson();
    }
    return data;
  }
}

class Follows {
  int? followerId;
  int? followingId;
  String? createdAt;
  String? updatedAt;

  Follows({this.followerId, this.followingId, this.createdAt, this.updatedAt});

  Follows.fromJson(Map<String, dynamic> json) {
    followerId = json['followerId'];
    followingId = json['followingId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followerId'] = this.followerId;
    data['followingId'] = this.followingId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
