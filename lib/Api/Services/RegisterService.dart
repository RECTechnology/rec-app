import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';

class RegisterService extends ServiceBase {
  RegisterService({Client client}) : super(client: client);

  Future register(RegisterData data) async {
    var body = data.toJson();

    return this.post(ApiPaths.register.toUri(), body);
  }
}
