import 'package:rec/Entities/Campaign.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Environments/env-local.dart';
import 'package:rec/Helpers/Checks.dart';

class User extends Entity {
  List<Account> accounts = [];
  List<Campaign> campaigns = [];

  Account selectedAccount;
  String username;
  String image;
  String phone;
  String prefix;
  String email;

  bool hasPin = false;
  bool privateTosCampaign = false;

  User({
    String id,
    String createdAt,
    String updatedAt,
    this.username,
    this.accounts,
    this.selectedAccount,
    this.hasPin = false,
    this.privateTosCampaign = false,
    this.phone = '',
    this.prefix = '',
    this.email = '',
  }) : super(id, createdAt, updatedAt);

  bool isCampaignActive(Campaign campaign) {
    return campaigns.contains(campaign);
  }

  bool isCampaignActiveById(String campaignId) {
    return campaigns.where((el) => el.id == campaignId) != null;
  }

  bool hasCampaignAccount() {
    return getCampaignAccount() != null;
  }

  /// Returns the campaign account for this user
  Account getCampaignAccount() {
    if (Checks.isEmpty(accounts)) return null;

    var ltabAccounts = accounts.where((el) => el.isPrivate()).where((account) {
      if (account.campaigns == null || account.campaigns.isEmpty) return false;

      var matchingCampaign =
          account.campaigns.where((campaign) => campaign.id == env.CAMPAIGN_ID);

      return matchingCampaign != null && matchingCampaign.isNotEmpty;
    });

    return ltabAccounts.isNotEmpty ? ltabAccounts.last : null;
  }

  /// Checks whether any [Account] of this [User] satisfies [test].
  /// Checks every account in iteration order, and returns true if any of them make [test] return true, otherwise returns false.
  bool anyAccountMatches(bool Function(Account account) test) {
    if (Checks.isEmpty(accounts)) return false;

    return accounts.any(test);
  }

  /// Checks whether this user has any account with a level that matches [code]
  /// Codes are available as constants in Level [Level.CODE_KYC2]
  bool anyAccountAtLevel(String code) {
    return anyAccountMatches(
      (account) => account.hasLevelByCode(code),
    );
  }

  String get formattedPhone => '(+$prefix) $phone';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      username: json['username'],
      phone: json['phone'].toString(),
      prefix: json['prefix'].toString(),
      hasPin: json['has_pin'],
      email: json['email'],
      privateTosCampaign: json['private_tos_campaign'],
      selectedAccount: Account.fromJson(json['active_group']),
      accounts: List.from(json['activeAccounts'])
          .map((el) => Account.fromJson(el))
          .toList(),
    );
  }
}
