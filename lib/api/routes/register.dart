import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class RegisterAPI {
  User? user;
  String? message;

  RegisterAPI({this.user, this.message});

  RegisterAPI.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['message'] = message;
    return data;
  }

  static Future<RegisterAPI> list(
    String username,
    String email,
    String password,
    String bio,
    String profilePicPath, // Path to the profile picture on the device
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.register}");

    // Create a map of the request body
    Map<String, String> body = {
      'username': username,
      'email': email,
      'password': password,
      'bio': bio,
    };

    // Add profilePicPath to the body if needed
    body['profilePic'] =
        profilePicPath; // Uncomment if the server expects this field

    try {
      // Send the request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Convert the response to a string
      final responseString = response.body;
      print(responseString);

      // Parse the response and return the RegisterAPI object
      return RegisterAPI.fromJson(jsonDecode(responseString));
    } catch (e) {
      print("Error from api: $e");
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
  String? updatedAt;
  String? createdAt;
  String? profilePic;

  User(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.bio,
      this.updatedAt,
      this.createdAt,
      this.profilePic});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    bio = json['bio'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['bio'] = bio;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    data['profilePic'] = profilePic;
    return data;
  }
}
