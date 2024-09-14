import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class FollowerAPI {
  int? followerCount;
  List<Followers>? followers;

  FollowerAPI({this.followerCount, this.followers});

  FollowerAPI.fromJson(Map<String, dynamic> json) {
    followerCount = json['followerCount'];
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(new Followers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followerCount'] = this.followerCount;
    if (this.followers != null) {
      data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Future<FollowerAPI> followerlist(int id) async {
    final Uri url =
        Uri.parse("${Webservice.rootURL}/api/users/${id}/followers");

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseString = response.body;
        print(responseString);

        FollowerAPI followerlist =
            FollowerAPI.fromJson(jsonDecode(responseString));
        return followerlist;
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

class Followers {
  int? id;
  String? username;
  String? email;
  Follows? follows;
  String? profilePic;

  Followers(
      {this.id, this.username, this.email, this.follows, this.profilePic});

  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    follows =
        json['Follows'] != null ? new Follows.fromJson(json['Follows']) : null;
    profilePic = json['profilePic'];
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
