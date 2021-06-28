import 'package:rec/Api/ApiPath.dart';

/// [API Documentation](https://github.com/QbitArtifacts/rec_app_v2/wiki/Api-Documentation) available.
class ApiPaths {
  // Transactions
  static ApiPath token = ApiPath('/oauth/v3/token');
  static ApiPath refreshToken = ApiPath('/oauth/v2/token');
  static ApiPath transactions = ApiPath('/user/v2/wallet/transactions');
  static ApiPath vendorData = ApiPath('/transaction/v1/vendor');
  static ApiPath payment = ApiPath('/methods/v1/out/rec');

  // Public
  static ApiPath sendPublicSmsCode = ApiPath('/app/v4/sms-code');
  static ApiPath recoverPassword = ApiPath('/app/v4/recover-password');
  static ApiPath verifyPhone = ApiPath('/app/v4/validate-phone');
  static ApiPath register = ApiPath('/app/v4/register');

  // Security
  static ApiPath changePassword = ApiPath(
    '/user/v4/users/security/change-password',
  );
  static ApiPath changePin = ApiPath(
    '/user/v4/users/security/change-pin',
  );
  static ApiPath sendUserSmsCode = ApiPath('/user/v4/users/security/sms-code');

  // User
  static ApiPath currentUserAccount = ApiPath('/user/v1/account');
  static ApiPath userAccounts = ApiPath('/user/v1/companies');
  static ApiPath changeAccount = ApiPath('/user/v1/activegroup');
  static ApiPath getContacts = ApiPath('/user/v1/public_phone_list');
  static ApiPath uploadFile = ApiPath('/user/v1/upload_file');
  static ApiPath listCards = ApiPath('/company/v1/credit_card');
  static ApiPath unlockUser = ApiPath('app/v4/unlock-user');

  static ApiPath campaigns = ApiPath('/user/v3/campaigns');

  // Accounts
  static ApiPath accounts = ApiPath('/user/v3/accounts');
  static ApiPath accountsSearch = ApiPath('/user/v4/accounts/search');
  static ApiPath accountsAddUser = ApiPath('/manager/v1/groups');
  static ApiPath accountsPermissions = ApiPath('/users/v1/usersbygroup');
  static ApiPath accountsEditRole = ApiPath('/manager/v1/groupsrole');
  static ApiPath accountsAddNew = ApiPath('/user/v1/new/account');

  // Recharge
  static ApiPath rechargeRecs = ApiPath('/methods/v1/in/lemonway');
  static ApiPath getExchangers = ApiPath('/user/v1/wallet/exchangers');

  // Documents
  static ApiPath documentKinds = ApiPath('/user/v3/document_kinds');
  static ApiPath documents = ApiPath('/user/v4/documents');
}
