import 'dart:io';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

import 'package:photo_manager/photo_manager.dart';

class CreatePostAPI {
  int? id;
  String? content;
  String? mediaUrl;
  String? mediaType;
  int? userId;
  String? updatedAt;
  String? createdAt;

  CreatePostAPI(
      {this.id,
      this.content,
      this.mediaUrl,
      this.mediaType,
      this.userId,
      this.updatedAt,
      this.createdAt});

  CreatePostAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    mediaUrl = json['mediaUrl'];
    mediaType = json['mediaType'];
    userId = json['userId'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['mediaUrl'] = this.mediaUrl;
    data['mediaType'] = this.mediaType;
    data['userId'] = this.userId;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }

  static Future<CreatePostAPI> postcreation(
    String content,
    AssetEntity media,
    String mediaType,
    int userId,
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.createpost}");

    // Convert the AssetEntity to a file (for media upload)
    File? file = await _convertAssetEntityToFile(media);
    print("file: $file");
    print("media: $media");
    print("mediaType: $mediaType");
    print("userId: $userId");
    // Prepare the request body with multipart
    var request = http.MultipartRequest('POST', url)
      ..fields['content'] = content
      ..fields['userId'] = "$userId"
      ..fields['mediaType'] = mediaType; // Fix the spread operator issue here

    // Add media file if it's available
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'media', // The field name for the media
        file.path,
      ));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print(response.body);
      if (response.statusCode == 201) {
        final responseString = response.body;
        print(responseString);

        // Parse the JSON response
        CreatePostAPI postcreation =
            CreatePostAPI.fromJson(jsonDecode(responseString));
        return postcreation;
      } else {
        print(response.body);
        throw Exception('Failed to upload post with media');
      }
    } catch (e) {
      print("Error from API: $e");
      throw e;
    }
  }

// Helper function to convert AssetEntity to File
  static Future<File?> _convertAssetEntityToFile(AssetEntity media) async {
    return await media.file;
  }
}
