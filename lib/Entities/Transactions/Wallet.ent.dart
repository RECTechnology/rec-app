import '../Currency.ent.dart';
// ignore: library_prefixes
import 'dart:math' as Math;

class Wallet {
  final Currency currency;
  final int balance;
  final int available;
  final String status;

  Wallet({
    this.currency,
    this.balance,
    this.available,
    this.status,
  });

  double getScaledBalance() {
    return balance / Math.pow(10, currency.scale);
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    //
    return Wallet(
      currency: Currency.find(json['currency']),
      balance: double.parse('${json['balance']}').toInt(),
      available: double.parse('${json['available']}').toInt(),
    );
  }
}
