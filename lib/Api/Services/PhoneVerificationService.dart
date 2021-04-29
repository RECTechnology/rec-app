import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Services/BaseService.dart';

class PhoneVerificationService extends ServiceBase {
  PhoneVerificationService({Client client}) : super(client: client);

  Future validateSMSCode({String NIF, String code}) async {
    var pathWithParams = ApiPaths.verifyPhone.withQueryParams({}).toUri();

    var body = {
      'code': int.parse(code),
      'NIF': NIF,
    };

    return this.post(pathWithParams, body);
  }
}
