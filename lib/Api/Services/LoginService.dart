import 'dart:convert';

import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Environments/env.dart';

class LoginService extends ServiceBase {
  LoginService({Client client})
      : super(
          client: client,
        );

  Future login({String username, String password}) async {


    var headers = await getHeaders();
    var body = json.encode({
      'username': username,
      'password': password,
      'grant_type': 'password',
      'client_id': env.CLIENT_ID,
      'client_secret': env.CLIENT_SECRET,
    });

    return client
        .post(
          ApiPaths.login.toUri(),
          headers: headers,
          body: body,
        )
        .then((res) => json.decode(res.body))
        .then(saveToken);
  }

  static dynamic saveToken(value) {
    Auth.saveTokenData(value);
    return value;
  }
}
