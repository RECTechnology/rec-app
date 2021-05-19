import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Account.ent.dart';

class AccountsService extends ServiceBase {
  AccountsService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  Future<Account> getOne(String id) async {
    var path = ApiPaths.bussinesDataService.withId(id).toUri();

    return this.get(path).then((value) {
      return _mapToObject(value);
    });
  }

  Account _mapToObject(Map<String, dynamic> data) =>
      Account.fromJson(data['data']);
}
