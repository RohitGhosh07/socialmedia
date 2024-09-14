import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kkh_events/api/Webservices.dart';
import 'dart:convert';

class VideoPostAPI {
  int? id;
  String? content;
  String? mediaUrl;
  String? mediaType;
  int? userId;
  String? updatedAt;
  String? createdAt;

  VideoPostAPI({
    this.id,
    this.content,
    this.mediaUrl,
    this.mediaType,
    this.userId,
    this.updatedAt,
    this.createdAt,
  });

  VideoPostAPI.fromJson(Map<String, dynamic> json) {
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

  static Future<VideoPostAPI> postcreation(
    String content,
    File media, // Video as media
    String mediaType,
    int userId,
    File thumbnailFile, // Image as thumbnail
  ) async {
    Uri url = Uri.parse("${Webservice.rootURL}/${Webservice.videopost}");

    if (media == null || thumbnailFile == null) {
      throw Exception('Media or thumbnail file cannot be null.');
    }

    // Prepare the request with multipart fields
    var request = http.MultipartRequest('POST', url)
      ..fields['content'] = content
      ..fields['userId'] = "$userId"
      ..fields['mediaType'] = mediaType;

    // Add the video file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'media', // The form field name for the video
      media.path,
    ));

    // Add the thumbnail image to the request
    request.files.add(await http.MultipartFile.fromPath(
      'thumbNail', // The form field name for the thumbnail image
      thumbnailFile.path,
    ));
    print("file: $thumbnailFile");
    print("media: $media");
    print("mediaType: $mediaType");
    print("userId: $userId");
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      if (response.statusCode == 201) {
        return VideoPostAPI.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to upload post with media and thumbnail.');
      }
    } catch (e) {
      throw Exception("Error from API: $e");
    }
  }
}
