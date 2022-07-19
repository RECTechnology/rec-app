import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';

import '../../test_utils.dart';

void main() {
  group('UserBalance', () {
    testWidgets('does build correctly', (tester) async {
      await tester.runAsync(() async {
        final userBalance = UserBalance();
        await tester.pumpWidget(
          await TestUtils.wrapPrivateRoute(userBalance),
        );

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();
        TestUtils.widgetExists(userBalance);
      });
    });

    testWidgets('formats ok', (tester) async {
      await tester.runAsync(() async {
        final userBalance = UserBalance();
        await tester.pumpWidget(
          await TestUtils.wrapPrivateRoute(userBalance),
        );

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();
        TestUtils.isTextPresent('0,00');
      });
    });

    testWidgets('formats ok with "en" locale', (tester) async {
      await tester.runAsync(() async {
        final userBalance = UserBalance(balance: 1718.686);
        await tester.pumpWidget(
          await TestUtils.wrapPrivateRoute(userBalance, locale: Locale('en')),
        );

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();
        TestUtils.isTextPresent('1,718.69');
      });
    });
  });
}
