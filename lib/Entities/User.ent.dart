import 'package:rec/Entities/Campaign.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Environments/env-local.dart';

class User extends Entity {
  List<Account> accounts = [];
  List<Campaign> campaigns = [];

  Account selectedAccount;
  String username;
  String image;
  String phone;
  String prefix;

  bool hasPin = false;

  User({
    String id,
    String createdAt,
    String updatedAt,
    this.username,
    this.accounts,
    this.selectedAccount,
    this.hasPin = false,
    this.phone = '',
    this.prefix = '',
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

  Account getCampaignAccount() {
    var ltabAccounts = accounts.where((el) => el.type == 'PRIVATE').where((el) {
      return el.campaigns != null
          ? el.campaigns.where((el) => el.id == env.CAMPAIGN_ID) != null
          : false;
    });

    return ltabAccounts.isNotEmpty ? ltabAccounts.last : null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      username: json['username'],
      phone: json['phone'].toString(),
      prefix: json['prefix'].toString(),
      hasPin: json['has_pin'],
      selectedAccount: Account.fromJson(json['active_group']),
      accounts: List.from(json['activeAccounts'])
          .map((el) => Account.fromJson(el))
          .toList(),
    );
  }
}
