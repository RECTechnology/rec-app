import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:http_interceptor/interceptor_contract.dart';
import 'package:rec/Api/Interceptors/ApiInterceptor.dart';

abstract class ServiceBase {
  Client client;

  ServiceBase({
    List<InterceptorContract> interceptors = const [],
    Client client,
  }) {
    this.client = client ??
        HttpClientWithInterceptor.build(
          interceptors: [
            ApiLoggerInterceptor(),
            ...interceptors,
          ],
        );
  }

  Future<Map<String, String>> getHeaders({
    String contentType = 'application/json',
    String accept = 'application/json',
  }) {
    return Future.value({
      'content-type': contentType,
      'accept': accept,
    });
  }

  Future<Map<String, dynamic>> put(Uri uri, Map data) async {
    return client
        .put(
          uri,
          headers: await getHeaders(),
          body: json.encode(data),
        )
        .then(onRequest);
  }

  Future<Map<String, dynamic>> post(Uri uri, Map<String, dynamic> body) async {
    return client
        .post(
          uri,
          headers: await getHeaders(),
          body: json.encode(body),
        )
        .then(onRequest);
  }

  Future delete(String id) {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> get(Uri url) async {
    return client
        .get(
          url,
          headers: await getHeaders(),
        )
        .then(onRequest);
  }

  FutureOr<Map<String, dynamic>> onRequest(Response response) {
    if (response.statusCode >= 400) {
      return Future.error({
        'code': response.statusCode,
        'body': json.decode(response.body),
      });
    }
    return json.decode(response.body);
  }
}
