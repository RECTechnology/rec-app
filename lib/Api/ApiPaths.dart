import 'package:rec/Api/ApiPath.dart';

/// [API Documentation](https://github.com/QbitArtifacts/rec_app_v2/wiki/Api-Documentation) available.
class ApiPaths {
  // Transactions
  static ApiPath token = ApiPath('/oauth/v3/token');
  static ApiPath transactions = ApiPath('/user/v2/wallet/transactions');
  static ApiPath vendorData = ApiPath('/transaction/v1/vendor');
  static ApiPath payment = ApiPath('/methods/v1/out/rec');

  // Public
  static ApiPath sendPublicSmsCode = ApiPath('/app/v4/sms-code');
  static ApiPath changePassword = ApiPath('/app/v4/recover-password');
  static ApiPath verifyPhone = ApiPath('/app/v4/validate-phone');
  static ApiPath register = ApiPath('/app/v4/register');

  // User
  static ApiPath currentUserAccount = ApiPath('/user/v1/account');
  static ApiPath userAccounts = ApiPath('/user/v1/companies');
  static ApiPath changeAccount = ApiPath('/user/v1/activegroup');
  static ApiPath listCards = ApiPath('/company/v1/credit_card');
  static ApiPath getContacts = ApiPath('/user/v1/public_phone_list');

  // Recharge
  static ApiPath rechargeRecs = ApiPath('/methods/v1/in/lemonway');
  static ApiPath getExchangers = ApiPath('/user/v1/wallet/exchangers');

  // Map
  static ApiPath mapService = ApiPath('/user/v4/accounts/search');
  static ApiPath bussinesDataService = ApiPath('/user/v3/accounts');
}
