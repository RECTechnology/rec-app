import 'package:rec/Entities/Campaign.ent.dart';
import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Transactions/Wallet.ent.dart';

import 'Activity.ent.dart';
import 'Product.ent.dart';

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
  List<dynamic> offers = [];

  String name;
  String companyImage;
  String publicImage;
  String type;
  String recAddress;
  String description;
  String schedule;
  String street;
  String webUrl;
  String phone;
  String prefix;

  bool active;

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
    this.street,
    this.prefix,
    this.phone,
    this.webUrl,
  }) : super(id, createdAt, updatedAt);

  bool isPrivate() {
    return type == Account.TYPE_PRIVATE;
  }

  bool isCompany() {
    return type == Account.TYPE_COMPANY;
  }

  Wallet getWallet(String currencyName) {
    return wallets
        .firstWhere((element) => element.currency.name == currencyName);
  }

  Wallet getWalletByCurrency(Currency currency) {
    return wallets.firstWhere((element) => element.currency == currency);
  }

  bool isCampaignActive(Campaign campaign) {
    return campaigns.contains(campaign);
  }

  bool isCampaignActiveById(String campaignId) {
    return campaigns.firstWhere((el) => el.id == campaignId) != null;
  }

  int getWalletBalance(String currencyName) {
    return wallets
        .firstWhere((element) => element.currency.name == currencyName)
        .balance;
  }

  int getWalletBalanceByCurrency(Currency currency) {
    return getWalletBalance(currency.name);
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    var wallets = <Wallet>[];
    var campaigns = <Campaign>[];

    if (json['wallets'] != null) {
      var jsonWallets = List.from(json['wallets']);
      wallets = jsonWallets.isNotEmpty
          ? jsonWallets.map<Wallet>((el) => Wallet.fromJson(el)).toList()
          : <Wallet>[];
    }

    if (json['campaigns'] != null) {
      var jsonCampaigns = List.from(json['campaigns']);
      campaigns = jsonCampaigns.isNotEmpty
          ? jsonCampaigns.map<Campaign>((el) => Campaign.fromJson(el)).toList()
          : <Campaign>[];
    }

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
      schedule: json['schedule'],
      prefix: json['prefix'],
      phone: json['phone'],
      wallets: wallets,
      campaigns: campaigns,
    );
  }
}
