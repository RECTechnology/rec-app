import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:http_interceptor/interceptor_contract.dart';
import 'package:rec/Api/Interceptors/ApiInterceptor.dart';
import 'package:rec/Api/Providers/AuthProvider.dart';

abstract class ServiceBase {
  Client client;

  ServiceBase({List<InterceptorContract> interceptors = const []}) {
    client = HttpClientWithInterceptor.build(
      interceptors: [
        ApiLoggerInterceptor(),
        ...interceptors,
      ],
    );
  }

  @protected
  Future<String> getToken() {
    return AuthProvider.getToken();
  }

  @protected
  Future<Map<String, String>> getHeaders({
    String contentType = 'application/json',
    String accept = 'application/json',
  }) {
    return Future.value({
      'content-type': contentType,
      'accept': accept,
    });
  }

  @protected
  Future put(String id, Map data) {
    throw UnimplementedError();
  }

  @protected
  Future post(Map data) {
    throw UnimplementedError();
  }

  @protected
  Future delete(String id) {
    throw UnimplementedError();
  }

  @protected
  Future get(String id) {
    throw UnimplementedError();
  }
}
