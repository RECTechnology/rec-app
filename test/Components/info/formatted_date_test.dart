import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Info/formatted_date.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('formattedDate works with locale "es"', (tester) async {
    await tester.runAsync(() async {
      final formattedDate = FormattedDate(
        date: DateTime.parse('2022-06-21 16:00:00'),
      );

      await tester.pumpWidget(
        await TestUtils.wrapPublicRoute(formattedDate, locale: Locale('es')),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();

      TestUtils.widgetExists(formattedDate);
      TestUtils.isTextPresent('Martes, 21 Jun. 2022 16:00');
    });
  });

  testWidgets('formattedDate works with locale "en"', (tester) async {
    await tester.runAsync(() async {
      final formattedDate = FormattedDate(
        date: DateTime.parse('2022-06-21 16:00:00'),
      );

      await tester.pumpWidget(
        await TestUtils.wrapPublicRoute(formattedDate, locale: Locale('en')),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();

      TestUtils.widgetExists(formattedDate);
      TestUtils.isTextPresent('Tuesday, Jun 21, 2022 16:00');
    });
  });
}
