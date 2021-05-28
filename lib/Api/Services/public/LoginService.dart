import 'dart:io';

import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/GrantTypes.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Forms/LoginData.dart';
import 'package:rec/Environments/env.dart';

class LoginService extends ServiceBase {
  LoginService({Client client}) : super(client: client);

  Future login(LoginData data) async {
    var body = {
      'username': data.username,
      'password': data.password,
      'version': data.version,
      'grant_type': GrantTypes.password,
      'client_id': env.CLIENT_ID,
      'client_secret': env.CLIENT_SECRET,
      'platform': Platform.operatingSystem,
    };

    return this.post(ApiPaths.token.toUri(), body).then(saveToken);
  }

  static Future saveToken(value) async {
    await Auth.saveTokenData(value);
    return value;
  }
}
