import 'package:kkh_events/admin/api_url.dart';
import 'package:kkh_events/admin/connection.dart';

class ClubsClass {
  String? club;

  ClubsClass({this.club});

  ClubsClass.fromJson(Map<String, dynamic> json) {
    club = json['club'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['club'] = club;
    return data;
  }

  static Future<List<ClubsClass>> getClubs() async {
    String url = "${ApiUrl.eventsApi}?action=clubs";
    final response = await DioClient().get(url);
    if (response != null && response.statusCode == 200) {
      List<ClubsClass> types = [];
      for (var item in response.data) {
        types.add(ClubsClass.fromJson(item));
      }
      return types;
    }
    return [];
  }
}
