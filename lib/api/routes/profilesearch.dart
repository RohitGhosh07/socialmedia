import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class ProfileSearchAPI {
  List<Users>? users;
  String? message;

  ProfileSearchAPI({this.users, this.message});

  ProfileSearchAPI.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }

  Future<ProfileSearchAPI> profilesearchresult(String query) async {
    final Uri url = Uri.parse(
        "${Webservice.rootURL}/${Webservice.profilesearch}?query=$query");

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseString = response.body;
        print(responseString);

        ProfileSearchAPI searchresult =
            ProfileSearchAPI.fromJson(jsonDecode(responseString));
        return searchresult;
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

class Users {
  int? id;
  String? username;
  String? email;
  String? bio;
  String? profilePic;

  Users({this.id, this.username, this.email, this.bio, this.profilePic});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    bio = json['bio'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['bio'] = this.bio;
    data['profilePic'] = this.profilePic;
    return data;
  }
}
