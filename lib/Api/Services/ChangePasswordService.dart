import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Services/BaseService.dart';

class ChangePasswordService extends ServiceBase {
  ChangePasswordService({Client client}) : super(client: client);

  Future changePassword({
    String password,
    String repassword,
    String accesToken,
    String code,
  }) async {
    var pathWithParams = ApiPaths.changePassword.toUri();
    var body = {
      'code': code,
      'password': password,
      'repassword': repassword,
    };

    return this.post(pathWithParams, body);
  }
}
