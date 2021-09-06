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
    var formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimals,
    );

    // Trim is done to remove trailing space when no symbol provided,
    // messed up tests and added unwanted space
    return amount == null ? '' : formatter.format(amount).trim();
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
