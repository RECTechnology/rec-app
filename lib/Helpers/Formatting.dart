import 'package:intl/intl.dart';

class Formatting {
  static String formatCurrency(
    double amount, {
    String locale = 'es_ES',
    String symbol = 'R',
  }) {
    var f = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );

    return f.format(amount);
  }
}
