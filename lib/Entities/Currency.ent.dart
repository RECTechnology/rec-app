class Currency {
  final String name;
  final String symbol;
  final double scale;
  final int decimals;

  Currency(
    this.name,
    this.symbol,
    this.scale,
    this.decimals,
  );

  static Currency rec = Currency('rec', 'R', 8, 2);
  static Currency eur = Currency('eur', '€', 2, 2);
  static List<Currency> all = [Currency.eur, Currency.rec];
  static Currency find(String name) {
    return Currency.all.firstWhere(
      (element) => element.name.toUpperCase() == name.toUpperCase(),
    );
  }
}
