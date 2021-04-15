import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/ServiceBase.dart';
import 'package:rec/Entities/User.ent.dart';

class UsersService extends ServiceBase {
  UsersService() : super(interceptors: [InjectTokenInterceptor()]);

  Future<User> getUser() {
    final uri = ApiPaths.currentUserAccount.toUri();
    return get(uri).then(_mapToUser);
  }

  Future<Map<String, dynamic>> changeAccount(String accountId) {
    final uri = ApiPaths.changeAccount.withQueryParams({
      'group_id': accountId,
    }).toUri();
    return put(uri, {'group_id': accountId});
  }

  User _mapToUser(Map<String, dynamic> resp) {
    return User.fromJson(resp['data']);
  }
}
