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

  /// Deprecated in favor of `ApiPath.append`
  @deprecated
  ApiPath withId(String id) {
    this.id = id;
    return this;
  }


  /// Returns a new ApiPath with a path segment appended to the path
  /// of the original ApiPath
  ApiPath append(String suffix) {
    var newApiPath = ApiPath('$path/$suffix');
    newApiPath.queryParams = queryParams;
    return newApiPath;
  }

  /// Returns a new ApiPath with a list of path segments appended to the path
  /// of the original ApiPath
  ApiPath appendMultiple(List<String> suffixes) {
    var newApiPath = ApiPath('$path/${suffixes.join('/')}');
    newApiPath.queryParams = queryParams;
    return newApiPath;
  }

  Uri toUri() {
    return Uri.https(
      env.API_URL,
      path + (id != null ? '/$id' : ''),
      queryParams,
    );
  }
}
