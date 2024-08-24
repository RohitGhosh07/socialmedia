import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ApiService {
  static const String rootUrl = 'https://salesmpower.acedns.in/kkh_events/';
  Future<List<ImageModel>> fetchImages(String? value) async {
    log('ApiService: ${rootUrl}cv_api.php?search=$value');

    final response =
        await http.get(Uri.parse('${rootUrl}cv_api.php?search=$value'));

    if (response.statusCode == 200) {
      log('Response: ${response.body}');
      log('Response: ${response.statusCode}');
      List<dynamic> data = json.decode(response.body);
      log('Data: $data');
      return data.map((json) => ImageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
