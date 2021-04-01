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

  User _mapToUser(Map<String, dynamic> resp) {
    return User.fromJson(resp['data']);
  }
}
