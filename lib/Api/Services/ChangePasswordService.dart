import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectAppTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';

class ChangePasswordService extends ServiceBase {
  ChangePasswordService({Client client})
      : super(
          client: client,
          interceptors: [InjectAppTokenInterceptor()],
        );

  Future changePassword({
    String password,
    String repassword,
    String code,
    String dni,
    String prefix,
    String phone,
  }) async {
    var pathWithParams = ApiPaths.changePassword.toUri();
    var body = {
      'password': password,
      'repassword': repassword,
      'smscode': code,
      'dni': dni,
      'prefix': prefix,
      'phone': phone,
    };

    return this.post(pathWithParams, body);
  }
}
