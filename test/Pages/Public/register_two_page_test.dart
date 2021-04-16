import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';
import 'package:rec/Providers/AppLocalizations.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('RegisterTwo test build correctly', (
    WidgetTester tester,
  ) async {
    final key = GlobalKey<NavigatorState>();

    // var app = TestUtils.wrapPublicRoute(RegisterTwo());
    // ModalRoute.of(app).settings.arguments
    //   await tester.pumpWidget(
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: Scaffold(
          body: Localizations(
            delegates: [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              AppLocalizations.delegate
            ],
            locale: Locale('es'),
            child: TextButton(
              onPressed: () => key.currentState.push(
                MaterialPageRoute<void>(
                  settings: RouteSettings(arguments: RegisterData()),
                  builder: (_) => RegisterTwo(),
                ),
              ),
              child: const SizedBox(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(RegisterTwo);
  });
}
