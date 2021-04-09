import 'package:rec/Base/Entity.base.dart';
import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Entities/Wallet.ent.dart';

import 'Activity.ent.dart';
import 'Product.ent.dart';

class Account extends Entity {
  static String TYPE_PRIVATE = 'PRIVATE';
  static String TYPE_COMPANY = 'COMPANY';

  List<Activity> activities = [];
  List<Product> producingProducts = [];
  List<Product> consumingProducts = [];
  List<Wallet> wallets = [];

  String name;
  String companyImage;
  String publicImage;
  String type;

  Account({
    String id,
    String createdAt,
    String updatedAt,
    this.name,
    this.type,
    this.activities,
    this.consumingProducts,
    this.producingProducts,
    this.companyImage,
    this.publicImage,
    this.wallets = const [],
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

  int getWalletBalance(String currencyName) {
    return wallets
        .firstWhere((element) => element.currency.name == currencyName)
        .balance;
  }

  int getWalletBalanceByCurrency(Currency currency) {
    return wallets
        .firstWhere((element) => element.currency == currency)
        .balance;
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    var wallets = List.from(json['wallets']);
    wallets = wallets.map((el) => Wallet.fromJson(el)).toList();

    return Account(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      name: json['name'],
      type: json['type'],
      publicImage: json['public_image'],
      companyImage: json['company_image'],
      wallets: wallets,
    );
  }
}
