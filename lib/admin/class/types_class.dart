import 'package:kkh_events/admin/api_url.dart';
import 'package:kkh_events/admin/connection.dart';

class TypesClass {
  String? area;

  TypesClass({this.area});

  TypesClass.fromJson(Map<String, dynamic> json) {
    area = json['area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area'] = area;
    return data;
  }

  static Future<List<TypesClass>> getTypes() async {
    String url = "${ApiUrl.eventsApi}?action=types";
    final response = await DioClient().get(url);
    if (response != null && response.statusCode == 200) {
      List<TypesClass> types = [];
      for (var item in response.data) {
        types.add(TypesClass.fromJson(item));
      }
      return types;
    }
    return [];
  }
}
