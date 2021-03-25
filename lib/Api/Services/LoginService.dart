import 'dart:convert';

import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Environments/env.dart';

class LoginService extends ServiceBase {
  LoginService() : super();

  Future login({String username, String password}) async {
    var headers = await getHeaders();
    return client.post(
      ApiPaths.login,
      headers: headers,
      body: json.encode({
        'username': username,
        'password': password,
        'grant_type': 'password',
        'client_id': env.CLIENT_ID,
        'client_secret': env.CLIENT_SECRET,
      }),
    );
  }
}
