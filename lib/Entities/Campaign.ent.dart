import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Providers/UserState.dart';

class Campaign extends Entity {
  DateTime initDate;
  DateTime endDate;

  int min;
  int max;
  int balance;

  String name;
  String videoPromoUrl;
  String imageUrl;

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
  }) : super(id, createdAt, updatedAt);

  bool isFinished() {
    var currentDate = DateTime.now();
    var diff = endDate.difference(currentDate);
    return diff.inSeconds <= 0;
  }

  bool isStarted() {
    var currentDate = DateTime.now();
    var diff = initDate.difference(currentDate);
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
    );
  }
}
