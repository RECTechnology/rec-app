import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Services/ServiceBase.dart';

class PhoneVerificationService extends ServiceBase {
  PhoneVerificationService({Client client}) : super(client: client);

  Future changePassword({String NIF, String accesToken, String code}) async {
    var pathWithParams = ApiPaths.verifyPhone
        .withQueryParams({'access_token': accesToken}).toUri();

    var body = {
      'code': code,
      'NIF': NIF,
    };

    return this.post(pathWithParams, body);
  }
}
