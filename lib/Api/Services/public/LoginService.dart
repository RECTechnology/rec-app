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
      ...data.toJson(),
      'grant_type': GrantTypes.password,
      'client_id': env.CLIENT_ID,
      'client_secret': env.CLIENT_SECRET,
      'platform': Platform.operatingSystem,
    };

    return this.post(ApiPaths.token.toUri(), body).then(saveToken);
  }

  Future refreshToken(String refreshToken) async {
    print('refreshRoken $refreshToken');
    var body = {
      'grant_type': GrantTypes.refreshToken,
      'client_id': env.CLIENT_ID,
      'client_secret': env.CLIENT_SECRET,
      'refresh_token': refreshToken,
    };

    return this.post(ApiPaths.refreshToken.toUri(), body).then(saveToken);
  }

  static Future saveToken(value) async {
    await Auth.saveTokenData(value);
    return value;
  }
}
