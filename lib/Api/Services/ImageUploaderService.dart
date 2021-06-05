import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:rec/Api/ApiError.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Helpers/Checks.dart';

class ImageUploaderService extends ServiceBase {
  final dio.Dio _dio = dio.Dio();

  ImageUploaderService() : super(interceptors: [InjectTokenInterceptor()]);

  Future uploadImage(var imagePath) async {
    var token = await Auth.getAccessToken();
    var formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(imagePath),
    });
    return _dio
        .post(
          ApiPaths.uploadFile.toUri().toString(),
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        )
        .then(_onDioResponse);
  }

  FutureOr<Map<String, dynamic>> _onDioResponse(dio.Response response) {
    if (response.statusCode >= 400) {
      return Future.error(ApiError.fromDioResponse(response));
    }
    return Future.value(
      Checks.isNotEmpty(response.data) ? response.data : {},
    );
  }
}
