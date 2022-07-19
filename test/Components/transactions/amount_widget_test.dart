import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/amount_widget.dart';
import 'package:rec/config/brand.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('AmountWidget should build  with positive number', (tester) async {
    await tester.runAsync(() async {
      var txAmount = AmountWidget(amount: 3);

      await tester.pumpWidget(
        TestUtils.wrapPublicRoute(txAmount),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();

      TestUtils.widgetExists(txAmount);
      TestUtils.isTextPresent('+3,00 R');

      final amountTextWidget = tester.firstWidget(find.byType(Text)) as Text;
      expect(amountTextWidget.style?.color, Brand.primaryColor);
    });
  });

  testWidgets('AmountWidget should build with positive number with many decimals', (tester) async {
    await tester.runAsync(() async {
      var txAmount = AmountWidget(amount: 3.12345);

      await tester.pumpWidget(
        TestUtils.wrapPublicRoute(txAmount),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();

      TestUtils.widgetExists(txAmount);
      TestUtils.isTextPresent('+3,12 R');

      final amountTextWidget = tester.firstWidget(find.byType(Text)) as Text;
      expect(amountTextWidget.style?.color, Brand.primaryColor);
    });
  });

  testWidgets('AmountWidget should build with negative number and locale "en"', (tester) async {
    await tester.runAsync(() async {
      var txAmount = AmountWidget(
        amount: 3,
        isNegative: true,
      );

      await tester.pumpWidget(
        TestUtils.wrapPublicRoute(txAmount, locale: Locale('en')),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();

      TestUtils.widgetExists(txAmount);
      TestUtils.isTextPresent('-3.00 R');

      final amountTextWidget = tester.firstWidget(find.byType(Text)) as Text;
      expect(amountTextWidget.style?.color, Brand.amountNegative);
    });
  });
}
