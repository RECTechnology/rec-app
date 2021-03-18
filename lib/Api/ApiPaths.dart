import 'package:rec/Environments/env.dart';

class ApiPaths {
  static String createPathForEnv(String path) {
    return '${env.API_URL}$path';
  }

  static String login = ApiPaths.createPathForEnv('/oauth/v3/token');
}
