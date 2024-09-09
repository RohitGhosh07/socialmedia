import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:kkh_events/api/class/User.dart';

class LoginAPI {
  String? token;
  String? message;
  User? user;

  LoginAPI({this.token, this.message, this.user});

  LoginAPI.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
    user = json['user'] != null ? User.fromMap(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['token'] = this.token;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toMap();
    }
    return data;
  }

  static Future<LoginAPI> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.login}");

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseString = response.body;
      print(responseString);

      LoginAPI loginResponse = LoginAPI.fromJson(jsonDecode(responseString));

      if (loginResponse.token != null && loginResponse.user != null) {
        // Use Hive to save user data
        var userAdapter = UserProvider(); // Create an instance of UserAdapter
        await userAdapter.saveUser(loginResponse.user!); // Save the user data
      }

      return loginResponse;
    } catch (e) {
      print("Error from api: $e");
      throw e;
    }
  }
}
