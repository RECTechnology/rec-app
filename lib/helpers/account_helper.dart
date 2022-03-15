import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountHelper {
  static bool isInLtabCampaign(Account account) =>
      account.campaigns.any((element) => element.code == env.CMP_LTAB_CODE);
  static bool isInCultureCampaign(Account account) =>
      account.campaigns.any((element) => element.code == env.CMP_CULT_CODE);

  static bool mapAccountIsInLtabCampaign(MapAccountData account) =>
      account.campaigns.any((element) => element.code == env.CMP_LTAB_CODE);
  static bool mapAccountIsInCultureCampaign(MapAccountData account) =>
      account.campaigns.any((element) => element.code == env.CMP_CULT_CODE);
}
