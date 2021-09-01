import 'package:rec/Api/ApiPaths.dart';

import 'package:rec/Api/Interceptors/InjectTokenInterceptor.dart';
import 'package:rec/Api/Services/BaseService.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class UsersService extends ServiceBase {
  UsersService() : super(interceptors: [InjectTokenInterceptor()]);

  Future<User> getUser() {
    final uri = ApiPaths.currentUserAccount.toUri();
    return get(uri).then(_mapToUser).then((value) {
      Sentry.configureScope((ctx) {
        ctx.user = SentryUser(
          username: value.username,
          id: value.id,
          email: value.email,
        );
      });
      return value;
    });
  }

  Future<Map<String, dynamic>> updateUser(Map<dynamic, dynamic> data) {
    final uri = ApiPaths.currentUserAccount.toUri();

    return put(uri, data);
  }

  Future<Map<String, dynamic>> changeLanguage(String locale) {
    final uri = ApiPaths.currentUserAccount.toUri();

    return put(uri, {'locale': locale});
  }

  Future<Map<String, dynamic>> changeAccount(String accountId) {
    final uri = ApiPaths.changeAccount.toUri();

    return put(uri, {'group_id': accountId});
  }

  User _mapToUser(Map<String, dynamic> resp) {
    return User.fromJson(resp['data']);
  }
}
