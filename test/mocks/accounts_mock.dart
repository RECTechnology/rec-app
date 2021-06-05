import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Currency.ent.dart';

class AccountsMock {
  static Account accountNormal = Account.fromJson({
    'name': 'test',
    'wallets': [
      {'currency': Currency.rec.name, 'balance': 0},
      {'currency': Currency.eur.name, 'balance': 0},
    ],
    'street': 'aaa',
    'address_number': 'aaa',
    'zip': 'aaa',
    'level': Map<String, dynamic>.from({'code': 'KYC2'}),
  });
}
