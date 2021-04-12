import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:http_interceptor/interceptor_contract.dart';
import 'package:rec/Api/Interceptors/ApiInterceptor.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Environments/env.dart';

import '../ApiPaths.dart';
import '../Storage.dart';

class ChangePasswordService extends ServiceBase {
  ChangePasswordService({Client client}) : super(client: client);


  Future changePassword({String password, String repassword,String accesToken,String code}) async {

    var pathWithParams = ApiPaths.changePassword.withQueryParams({ 'access_token': accesToken }).toUri();

    var body = {
      'code': code,
      'password': password,
      'repassword': repassword,
    };

    return this.post(pathWithParams, body);
  }



}
