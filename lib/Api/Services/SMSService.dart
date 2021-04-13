import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Environments/env.dart';

class SMSService extends ServiceBase {
  SMSService({Client client}) : super(client: client);

  Future sendSMS({String dni, String phone, String accesToken}) async {
    var pathWithParams = ApiPaths.sendRecoverSms
        .withQueryParams({'access_token': accesToken}).toUri();

    var body = {
      'dni': dni,
      'phone': phone,
      'client_secret': env.CLIENT_SECRET,
    };

    return this.post(pathWithParams, body);
  }
}
