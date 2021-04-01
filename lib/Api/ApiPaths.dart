import 'package:rec/Api/ApiPath.dart';

class ApiPaths {
  static ApiPath token = ApiPath('/oauth/v3/token');
  static ApiPath transactions = ApiPath('/user/v2/wallet/transactions');

  // current user
  static ApiPath currentUserAccount = ApiPath('/user/v1/account');
  static ApiPath userAccounts = ApiPath('/user/v1/companies');
}
