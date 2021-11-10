import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/Entities/Campaign.ent.dart';
import 'package:rec/Entities/Transactions/Currency.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/FormattedAddress.dart';
import 'package:rec/Entities/Level.ent.dart';
import 'package:rec/Entities/Offer.ent.dart';
import 'package:rec/Entities/Schedule/Schedule.ent.dart';
import 'package:rec/Entities/Transactions/Wallet.ent.dart';
import 'package:rec/Helpers/Checks.dart';

import 'Activity.ent.dart';
import 'Product.ent.dart';

/// This entity hold the information for an [Account]
class Account extends Entity {
  static const String TYPE_PRIVATE = 'PRIVATE';
  static const String TYPE_COMPANY = 'COMPANY';

  static const String SUBTYPE_COMPANY_RETAILER = 'RETAILER';
  static const String SUBTYPE_COMPANY_WHOLESALE = 'WHOLESALE';

  static const String SUBTYPE_COMPANY_NORMAL = 'NORMAL';
  static const String SUBTYPE_COMPANY_BMINCOME = 'BMINCOME';

  List<Activity> activities = [];
  List<Product> producingProducts = [];
  List<Product> consumingProducts = [];
  List<Wallet> wallets = [];
  List<Campaign> campaigns = [];
  List<Offer> offers = [];

  String name;
  String companyImage;
  String publicImage;
  String type;
  String recAddress;
  String description;
  String webUrl;
  String email;
  String phone;
  String prefix;

  Level level;
  Schedule schedule;

  FormattedAddress address;
  String scheduleString;
  String addressString;
  double latitude;
  double longitude;

  num redeemableAmount;

  bool active;
  bool hasOffers;
  bool isInLtabCampaign;

  Account({
    String id,
    String createdAt,
    String updatedAt,
    this.name,
    this.active,
    this.type,
    this.activities,
    this.consumingProducts,
    this.producingProducts,
    this.companyImage,
    this.publicImage,
    this.wallets = const [],
    this.campaigns = const [],
    this.recAddress,
    this.description,
    this.schedule,
    this.latitude,
    this.longitude,
    this.addressString,
    this.address,
    this.level,
    this.prefix,
    this.phone,
    this.webUrl,
    this.email,
    this.offers,
    this.scheduleString,
    this.redeemableAmount,
    this.isInLtabCampaign = false,
    this.hasOffers,
  }) : super(id, createdAt, updatedAt);

  bool isPrivate() {
    return type == Account.TYPE_PRIVATE;
  }

  bool isCompany() {
    return type == Account.TYPE_COMPANY;
  }

  bool hasWeb() {
    return Checks.isNotEmpty(webUrl);
  }

  bool hasPublicImage() {
    return Checks.isNotEmpty(publicImage);
  }

  Wallet getWallet(String currencyName) {
    return wallets
        .firstWhere((element) => element.currency.name == currencyName);
  }

  Wallet getWalletByCurrency(Currency currency) {
    return wallets.firstWhere((element) => element.currency == currency);
  }

  bool isCampaignActive(Campaign campaign) {
    return campaigns != null && campaigns.contains(campaign);
  }

  bool isCampaignActiveById(String campaignId) {
    return campaigns != null &&
        campaigns.isNotEmpty &&
        campaigns.firstWhere((el) => el.id == campaignId) != null;
  }

  LatLng getLatLong() => LatLng(latitude, longitude);

  // LTAB
  bool isLtabAccount({String ltabAccountName = 'LI TOCA AL BARRI'}) {
    return name == ltabAccountName;
  }

  bool hasLevel(Level level) {
    return level == this.level;
  }

  bool hasLevelByCode(String code) {
    return level != null && level.code == code;
  }

  int getWalletBalance(String currencyName) {
    return wallets
        .firstWhere((element) => element.currency.name == currencyName)
        .balance;
  }

  int getWalletBalanceByCurrency(Currency currency) {
    return getWalletBalance(currency.name);
  }

  String get fullPhone =>
      '${prefix.startsWith('+') ? prefix : '+' + prefix} $phone';

  factory Account.fromJson(Map<String, dynamic> json) {
    var wallets = <Wallet>[];
    var campaigns = <Campaign>[];
    var offers = <Offer>[];

    if (json['wallets'] != null) {
      var jsonWallets = List.from(json['wallets']);
      wallets = jsonWallets.isNotEmpty
          ? jsonWallets.map<Wallet>((el) => Wallet.fromJson(el)).toList()
          : <Wallet>[];
    }

    if (json['campaigns'] != null) {
      var jsonCampaigns = List.from(json['campaigns']);
      try {
        campaigns = jsonCampaigns.isNotEmpty
            ? jsonCampaigns
                .map<Campaign>((el) => Campaign.fromJson(el))
                .toList()
            : <Campaign>[];
      } catch (e) {
        // TODO: remove in next big version
      }
    }

    if (json['offers'] != null) {
      var jsonOffers = List.from(json['offers']);
      offers = jsonOffers.isNotEmpty
          ? jsonOffers.map<Offer>((el) => Offer.fromJson(el)).toList()
          : <Offer>[];
    }

    var formattedAddress = FormattedAddress.fromJson(json);
    var addressString = formattedAddress.toString();

    return Account(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      name: json['name'] == null || json['name'].isEmpty
          ? 'PARTICULAR'
          : json['name'],
      type: json['type'],
      active: json['active'],
      publicImage: json['public_image'],
      companyImage: json['company_image'],
      recAddress: json['rec_address'],
      description: json['description'],
      schedule: Schedule.fromJsonString(json['schedule']),
      scheduleString: json['schedule'],
      prefix: json['prefix'],
      phone: json['phone'],
      email: json['email'],
      latitude: double.parse((json['latitude'] ?? 0).toString()),
      longitude: double.parse((json['longitude'] ?? 0).toString()),
      redeemableAmount: json['redeemable_amount'],
      level: Checks.isNotNull(json['level'])
          ? Level.fromJson(json['level'])
          : null,
      wallets: wallets,
      campaigns: campaigns,
      offers: offers..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)),
      webUrl: json['web'],
      addressString: addressString,
      address: formattedAddress,
      hasOffers: json['has_offers'],
      isInLtabCampaign: json['in_ltab_campaign'],
    );
  }
}
