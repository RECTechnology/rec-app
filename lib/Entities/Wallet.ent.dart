import 'Currency.ent.dart';

class Wallet {
  final Currency currency;
  final double balance;
  final double available;

  Wallet(
    this.currency,
    this.balance,
    this.available,
  );
}
