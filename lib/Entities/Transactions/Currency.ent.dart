import 'package:intl/intl.dart';

class Currency {
  final String name;
  final String symbol;
  final double scale;
  final int decimals;

  const Currency(
    this.name,
    this.symbol,
    this.scale,
    this.decimals,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'scale': scale,
      'decimals': decimals,
    };
  }

  static String format(
    num amount, {
    String symbol = '',
    String locale = 'es_ES',
    num decimals = 2,
  }) {
    var f = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimals,
    );

    return f.format(amount);
  }

  static const Currency rec = Currency('rec', 'R', 8, 2);
  static const Currency eur = Currency('eur', '€', 2, 2);

  static List<Currency> all = [Currency.eur, Currency.rec];
  static Currency find(String name) {
    return Currency.all.firstWhere(
      (element) => element.name.toUpperCase() == name.toUpperCase(),
    );
  }
}
