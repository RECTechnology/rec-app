import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectAppTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';

class PhoneVerificationService extends ServiceBase {
  PhoneVerificationService({Client client})
      : super(
          client: client,
          interceptors: [InjectAppTokenInterceptor()],
        );

  Future validatePhone({
    String dni,
    String smscode,
    String prefix,
    String phone,
  }) async {
    var pathWithParams = ApiPaths.verifyPhone.withQueryParams({}).toUri();

    var body = {
      'smscode': int.parse(smscode),
      'dni': dni,
      'prefix': prefix,
      'phone': phone,
    };

    return this.post(pathWithParams, body);
  }
}
