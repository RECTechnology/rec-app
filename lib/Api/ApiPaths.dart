import 'package:rec/Api/ApiPath.dart';

class ApiPaths {
  static ApiPath token = ApiPath('/oauth/v3/token');
  static ApiPath transactions = ApiPath('/user/v2/wallet/transactions');
  static ApiPath vendorData = ApiPath('/transaction/v1/vendor');
  static ApiPath payment = ApiPath('/methods/v1/out/rec');

  static ApiPath sendRecoverSms = ApiPath('/password_recovery/v1/request');
  static ApiPath mapService = ApiPath('/user/v4/accounts/search');
  static ApiPath bussinesDataService = ApiPath('/user/v3/accounts');

  static ApiPath changePassword = ApiPath('/password_recovery/v1');
  static ApiPath verifyPhone = ApiPath('/kyc/validate_phone_code');
  static ApiPath register = ApiPath('/register/v4/mobile');

  // current user
  static ApiPath currentUserAccount = ApiPath('/user/v1/account');
  static ApiPath userAccounts = ApiPath('/user/v1/companies');
  static ApiPath changeAccount = ApiPath('/user/v1/activegroup');
  static ApiPath listCards = ApiPath('/company/v1/credit_card');

  static ApiPath getContacts = ApiPath('/user/v1/public_phone_list');

  // recharge
  static ApiPath rechargeRecs = ApiPath('/methods/v1/in/lemonway');
  static ApiPath getExchangers = ApiPath('/user/v1/wallet/exchangers');
}
