import 'package:rec/Api/ApiAdapter.dart';
import 'package:rec/Api/ApiClient.dart';
import 'package:rec/Api/Services/ServiceBase.dart';

class UsersService extends ServiceBase {
  UsersService({
    ApiClient client,
    List<ApiAdapter> adapters,
    ApiAdapter defaultAdater,
  }) : super(client, adapters, defaultAdater);

  String getPath({String method, Map params}) {
    switch (method) {
      case 'get':
        return '/user/users/${params['id']}';
      case 'list':
        return '/user/users';
    }

    return null;
  }

  @override
  ApiAdapter getAdapter({String method, Map params}) {
    switch (method) {
      default:
        return this.adapters.firstWhere((element) => element.name == 'http');
    }
  }
}
