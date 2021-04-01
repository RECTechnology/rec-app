import 'dart:convert';

import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/GrantTypes.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Environments/env.dart';

class AppService extends ServiceBase {
  AppService({Client client}) : super(client: client);

  Future getAppToken({String username, String password}) async {
    var headers = await getHeaders();
    var body = json.encode({
      'grant_type': GrantTypes.clientCredentials,
      'client_id': env.CLIENT_ID,
      'client_secret': env.CLIENT_SECRET,
    });

    return client
        .post(
          ApiPaths.token.toUri(),
          headers: headers,
          body: body,
        )
        .then((res) => json.decode(res.body))
        .then(saveToken);
  }

  static dynamic saveToken(value) {
    Auth.saveAppTokenData(value);
    return value;
  }
}
