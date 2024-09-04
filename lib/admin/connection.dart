import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

class DioClient {
  final dio = Dio();

  Future<Response?> get(String apiUrl) async {
    var headerOptions = Options(
      headers: {
        'Accept': "application/json",
      },
    );

    try {
      Response response = await dio.get(apiUrl, options: headerOptions);

      return response;
    } on DioException catch (e) {
      log(e.response.toString());
    } catch (error, stacktrace) {
      log("Exception occured: $error stackTrace: $stacktrace");
    }
    return null;
  }

  Future<Response?> post(String apiUrl, dynamic params, File? file) async {
    var headerOptions = Options(
      headers: {
        'Accept': "application/json",
      },
    );

    if (file != null) {
      params['image'] = await MultipartFile.fromFile(file.path);
    }

    try {
      Response response = await dio.post(apiUrl,
          data: FormData.fromMap(params), options: headerOptions);
      log(response.toString());
      return response;
    } on DioException catch (e) {
      log(e.response.toString());
    } catch (error, stacktrace) {
      log("Exception occured: $error stackTrace: $stacktrace");
    }
    return null;
  }
}
