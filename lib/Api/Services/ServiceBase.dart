import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:http_interceptor/interceptor_contract.dart';
import 'package:rec/Api/Interceptors/ApiInterceptor.dart';
import 'package:rec/Api/Auth.dart';

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

  Future<String> getToken() {
    return Auth.getToken();
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

  Future put(String id, Map data) {
    throw UnimplementedError();
  }

  Future post(Map data) {
    throw UnimplementedError();
  }

  Future delete(String id) {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> get(Uri url) async {
    return client
        .get(url, headers: await getHeaders())
        .then((value) => json.decode(value.body)['data']);
  }
}
