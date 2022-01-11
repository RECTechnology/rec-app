import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Helpers/DateHelper.dart';

class Campaign extends Entity {
  DateTime initDate;
  DateTime endDate;

  int min;
  int max;
  int balance;
  num percent;

  String name;
  String videoPromoUrl;
  String imageUrl;

  // implemented from: https://github.com/QbitArtifacts/rec_app_v2/issues/342
  bool bonusEnabled;

  Campaign({
    String id,
    String createdAt,
    String updatedAt,
    this.initDate,
    this.endDate,
    this.min,
    this.max,
    this.balance,
    this.name,
    this.videoPromoUrl,
    this.imageUrl,
    this.percent,
    this.bonusEnabled,
  }) : super(id, createdAt, updatedAt);

  bool isFinished() {
    return true;
    var diff = DateHelper.differenceFromNow(endDate);

    return diff.inSeconds <= 0;
  }

  bool isStarted() {
    var diff = DateHelper.differenceFromNow(initDate);

    return diff.inSeconds <= 0;
  }

  bool isActiveForState(UserState userState) {
    return isActive(this, userState.user, userState.account);
  }

  /// Checks if this campaign is active for [user] and [account]
  static bool isActive(Campaign campaign, User user, Account account) {
    var campaignStarted = campaign.isStarted();
    var isInCampaign = user.hasCampaignAccount();
    var isCompany = account.isCompany();

    return campaignStarted && !isInCampaign && !isCompany;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'init_date': initDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'min': min,
      'max': max,
      'balance': balance,
      'name': name,
      'video_promo_url': videoPromoUrl,
      'image_url': imageUrl,
      'bonus_enabled': bonusEnabled,
    };
  }

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      initDate: DateTime.parse(json['init_date']),
      endDate: DateTime.parse(json['end_date']),
      min: json['min'],
      max: json['max'],
      balance: json['balance'],
      name: json['name'],
      videoPromoUrl: json['video_promo_url'],
      imageUrl: json['image_url'],
      percent: json['redeemable_percentage'],
      bonusEnabled: json['bonus_enabled'] ?? false,
    );
  }
}
