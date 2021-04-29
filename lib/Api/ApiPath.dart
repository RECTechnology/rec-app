import 'package:rec/Environments/env.dart';

class ApiPath {
  String path;
  String id;
  Map<String, dynamic> queryParams = {};

  ApiPath(this.path);

  ApiPath withQueryParams(Map<String, dynamic> params) {
    queryParams = params;
    return this;
  }

  ApiPath withId(String id) {
    this.id = id;
    return this;
  }

  Uri toUri() {
    return Uri.https(
      env.API_URL,
      path + (id != null ? '/id' : ''),
      queryParams,
    );
  }
}
