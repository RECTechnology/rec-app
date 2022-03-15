import 'package:rec_api_dart/rec_api_dart.dart';

class AccountsMock {
  static Map<String, dynamic> accountNormalJson = {
    'name': 'test',
    'wallets': [
      {'currency': Currency.rec.name, 'balance': 0},
      {'currency': Currency.eur.name, 'balance': 0},
    ],
    'street': 'aaa',
    'address_number': 'aaa',
    'zip': 'aaa',
    'level': Map<String, dynamic>.from({'code': 'KYC2'}),
    'schedule': ''
  };
    static Map<String, dynamic> accountLtabJson = {
    'name': 'LI TOCA AL BARRI',
    'wallets': [
      {'currency': Currency.rec.name, 'balance': 0},
      {'currency': Currency.eur.name, 'balance': 0},
    ],
    'street': 'aaa',
    'address_number': 'aaa',
    'zip': 'aaa',
    'level': Map<String, dynamic>.from({'code': 'KYC2'}),
    'schedule': ''
  };
  static Account accountNormal = Account.fromJson(accountNormalJson);
  static Account accountLtab = Account.fromJson(accountLtabJson);
}
