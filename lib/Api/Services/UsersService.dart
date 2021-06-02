import 'package:dio/dio.dart';
import 'package:rec/Api/ApiPaths.dart';
import 'package:rec/Api/Auth.dart';
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

  Future getImageURL(var imagePath) async {
    var token = await Auth.getAccessToken();
    var formData =
    FormData.fromMap({'file': await MultipartFile.fromFile(imagePath)});
    var dio = Dio();
    return dio.post(ApiPaths.uploadFile.toUri().toString(),
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
  }

  Future<Map<String, dynamic>> changeIdiom(String locale) {
    RecStorage().write(key: 'locale', value: locale);
    final uri = ApiPaths.uploadFile.withQueryParams({
      'locale': locale,
    }).toUri();
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
