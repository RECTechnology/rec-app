import 'dart:convert';

import 'package:http/http.dart';
import 'package:dio/dio.dart' as dio;

class ApiError {
  String message;
  String type;
  int code;

  ApiError({
    this.message,
    this.type,
    this.code,
  });

  ApiError.fromResponse(Response response) {
    var body = json.decode(response.body);

    code = response.statusCode;
    message =
        body['message'] ?? body['status_text'] ?? body['error_description'];
    type = body['message'];
  }

  ApiError.fromDioResponse(dio.Response response) {
    var body = json.decode(response.data);

    code = response.statusCode;
    message =
        body['message'] ?? body['status_text'] ?? body['error_description'];
    type = body['message'];
  }
}
