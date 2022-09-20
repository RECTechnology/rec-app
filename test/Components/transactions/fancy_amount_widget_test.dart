import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/amount_widget.dart';
import 'package:rec/config/themes/rec.dart';

import '../../test_utils.dart';

void main() {
  group('FancyAmountWidget', () {
    testWidgets('with positive number', (tester) async {
      await tester.runAsync(() async {
        final txAmount = FancyAmountWidget(amount: 3);

        await tester.pumpWidget(
          TestUtils.wrapInMaterialApp(txAmount),
        );

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();

        TestUtils.widgetExists(txAmount);
        TestUtils.isRichTextPresent('+3,00 R');

        final amountTextWidget = tester.firstWidget(find.byType(RichText)) as RichText;
        final color = (amountTextWidget.text as TextSpan).style?.color;
        expect(color, recTheme.primaryColor);
      });
    });

    testWidgets('with negative number', (tester) async {
      await tester.runAsync(() async {
        final txAmount = FancyAmountWidget(
          amount: 3,
          isNegative: true,
        );

        await tester.pumpWidget(
          TestUtils.wrapInMaterialApp(txAmount),
        );

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();

        TestUtils.widgetExists(txAmount);
        TestUtils.isRichTextPresent('-3,00 R');

        final amountTextWidget = tester.firstWidget(find.byType(RichText)) as RichText;
        final color = (amountTextWidget.text as TextSpan).style?.color;
        expect(color, recTheme.red);
      });
    });
  });
}
