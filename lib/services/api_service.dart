import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ApiService {
  static const String rootUrl = 'https://salesmpower.acedns.in/swipecv/';

  Future<List<ImageModel>> fetchImages(String? value) async {
    final response = await http.get(Uri.parse('${rootUrl}cv_api.php?search=$value'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ImageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
