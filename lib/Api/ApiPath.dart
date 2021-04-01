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
