import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kkh_events/api/webservices.dart';

class ChatIdAPI {
  int? chatId;
  OtherUser? otherUser;
  String? lastMessage;
  String? lastMessageTime;
  String? lastMessageTimestamp;

  ChatIdAPI(
      {this.chatId,
      this.otherUser,
      this.lastMessage,
      this.lastMessageTime,
      this.lastMessageTimestamp});

  ChatIdAPI.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    otherUser = json['otherUser'] != null
        ? OtherUser.fromJson(json['otherUser'])
        : null;
    lastMessage = json['lastMessage'];
    lastMessageTime = json['lastMessageTime'];
    lastMessageTimestamp = json['lastMessageTimestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    if (otherUser != null) {
      data['otherUser'] = otherUser!.toJson();
    }
    data['lastMessage'] = lastMessage;
    data['lastMessageTime'] = lastMessageTime;
    data['lastMessageTimestamp'] = lastMessageTimestamp;
    return data;
  }

  // Updated method to handle a list of chats
  static Future<List<ChatIdAPI>> chatlist(int userId) async {
    final Uri url = Uri.parse(
        "${Webservice.rootURL}/${Webservice.chatidandprofile}/${userId}/ids"); // Update with your actual URL

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        // Map each item in the list to a ChatIdAPI object
        return responseData
            .map((chatData) => ChatIdAPI.fromJson(chatData))
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

class OtherUser {
  int? id;
  String? username;
  String? profilePic;

  OtherUser({this.id, this.username, this.profilePic});

  OtherUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['profilePic'] = profilePic;
    return data;
  }
}
