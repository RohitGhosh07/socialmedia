import 'dart:convert';

import 'package:get/get.dart';
import 'package:kkh_events/admin/api_url.dart';
import 'package:kkh_events/admin/connection.dart';
import 'package:kkh_events/admin/contstants.dart';
import 'package:kkh_events/storage/get_storage.dart';

class LoginApiClass {
  String? message;
  bool? success;
  String? username;

  LoginApiClass({this.message, this.success, this.username});

  LoginApiClass.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    data['username'] = username;
    return data;
  }

  static Future<LoginApiClass?> loginApi(
      String username, String password) async {
    final response = await DioClient().post(
        ApiUrl.loginApi,
        {
          'username': username,
          'password': password,
        },
        null);
    if (response != null && response.statusCode == 200) {
      return LoginApiClass.fromJson(
          jsonDecode(response.data.toString().trim()));
    }
    return null;
  }

  // save data to get storage
  static Future<void> saveData(LoginApiClass loginApiClass) async {
    Get.find<Storage>().storeValue(Contstants.userProfile, loginApiClass);
  }

  // get data from get storage
  static LoginApiClass? getData() {
    return Get.find<Storage>().getValue(Contstants.userProfile);
  }

  // clear data from get storage
  static void clearData() {
    Get.find<Storage>().clearData();
  }

  // check if user is logged in
  static bool isLoggedIn() {
    return Get.find<Storage>().getValue(Contstants.userProfile) != null;
  }
}
