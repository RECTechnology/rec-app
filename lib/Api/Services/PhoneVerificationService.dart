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

class PhoneVerificationService extends ServiceBase {
  PhoneVerificationService({Client client}) : super(client: client);


  Future changePassword({String NIF , String accesToken,String code}) async {

    var pathWithParams = ApiPaths.verifyPhone.withQueryParams({ 'access_token': accesToken }).toUri();

    var body = {
      'code': code,
      'NIF': NIF,
    };

    return this.post(pathWithParams, body);
  }



}
