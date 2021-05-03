import 'package:http/http.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/BussinesData.ent.dart';

class BussinesDataService extends ServiceBase {
  BussinesDataService({Client client})
      : super(
          client: client,
          interceptors: [InjectTokenInterceptor()],
        );

  Future<Account> getData(String id) async {
    var pathWithParams =
        ApiPaths.bussinesDataService.withQueryParams({}).withId(id).toUri();

    return this.get(pathWithParams).then((value) {
      return _mapToObject(value);
    });
  }

  Account _mapToObject(Map<String, dynamic> data) {
    return Account.fromJson(data['data']);
  }
}
