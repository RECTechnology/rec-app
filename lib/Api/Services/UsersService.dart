import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Entities/User.ent.dart';

class UsersService extends ServiceBase {
  UsersService() : super(interceptors: [InjectTokenInterceptor()]);

  Future<User> getUser() {
    final uri = ApiPaths.currentUserAccount.toUri();
    return get(uri).then(_mapToUser);
  }

  Future<Map<String, dynamic>> updateUser(Map<dynamic, dynamic> data) {
    final uri = ApiPaths.currentUserAccount.toUri();

    return put(uri, data);
  }

  Future<Map<String, dynamic>> changeIdiom(String locale) {
    final uri = ApiPaths.currentUserAccount.toUri();
    RecSecureStorage().write(key: 'locale', value: locale);

    return put(uri, {'locale': locale});
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
