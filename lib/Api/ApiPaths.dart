import 'package:rec/Environments/env.dart';

class ApiPath {
  final String path;
  Map<String, dynamic> queryParams = {};

  ApiPath(this.path);

  ApiPath withQueryParams(Map<String, dynamic> params) {
    queryParams = params;
    return this;
  }

  Uri toUri() {
    return Uri.https(env.API_URL, path, queryParams);
  }
}

class ApiPaths {
  static ApiPath createApiPath(String path) {
    return ApiPath(path);
  }

  static ApiPath login = ApiPaths.createApiPath(
    '/oauth/v3/token',
  );
  static ApiPath transactions = ApiPaths.createApiPath(
    '/user/v2/wallet/transactions',
  );
}
