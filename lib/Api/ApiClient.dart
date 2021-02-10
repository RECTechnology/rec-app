import 'package:rec/Api/ApiAdapter.dart';
import 'package:rec/Api/Services/UserService.dart';

class ApiClient {
  List<ApiAdapter> adapters = [];

  UsersService users;

  ApiClient({List<ApiAdapter> adapters}) {
    if (adapters == null || adapters.isEmpty) {
      throw 'ApiClient requires at least one adapter to be passed';
    }

    this.adapters = adapters;
    this.users = UsersService(client: this, adapters: adapters);
  }
}
