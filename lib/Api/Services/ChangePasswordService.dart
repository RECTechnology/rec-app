import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Services/ServiceBase.dart';

class ChangePasswordService extends ServiceBase {
  ChangePasswordService({Client client}) : super(client: client);

  Future changePassword({
    String password,
    String repassword,
    String accesToken,
    String code,
  }) async {
    print("Im in change password");
    var pathWithParams = ApiPaths.changePassword
        .withQueryParams({ }).toUri();

    var body = {
      'code': code,
      'password': password,
      'repassword': repassword,
    };

    return this.post(pathWithParams, body);
  }
}
