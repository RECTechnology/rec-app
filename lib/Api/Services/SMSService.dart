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

class SMSService extends ServiceBase {
  SMSService({Client client}) : super(client: client);


  Future sendSMS({String dni, String phone,String accesToken}) async {

    var pathWithParams = ApiPaths.sendRecoverSms.withQueryParams({ 'access_token': accesToken }).toUri();
    var body = {
      'dni':dni,
      'phone': phone,
      'client_secret': env.CLIENT_SECRET,
    };

    return this.post(pathWithParams, body);
  }



}
