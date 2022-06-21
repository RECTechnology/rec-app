import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Pages/Public/SmsCode/SmsCode.dart';

import '../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('SmsCode test build correctly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final app = await TestUtils.wrapPrivateRoute(
        SmsCode(
          dni: '80008000q',
          prefix: '34',
          phone: '605450083',
          onCode: (String code) {},
        ),
      );

      await tester.pumpWidget(app);

      // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }

      // comprueba que haya una instanncia de SmsCode visible
      TestUtils.widgetExistsByType(SmsCode);

      // Comprueba que se muestre el numero de telefono al que se ha enviado el sms
      TestUtils.isTextPresent('605450083');
    });
  });

  testWidgets('SmsCode validates and submits correctly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      String? onCodeResult;
      final key = GlobalKey<SmsCodeState>();
      final app = await TestUtils.wrapPrivateRoute(
        SmsCode(
          key: key,
          dni: '80008000q',
          prefix: '34',
          phone: '605450083',
          onCode: (String code) {
            onCodeResult = code;
          },
        ),
      );

      await tester.pumpWidget(app);

      // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }


      final smsCodeState = key.currentState!;

      // By default form should be invalid
      expect(smsCodeState.isFormValid, false);

      // Set correct smsCode
      // ignore: invalid_use_of_protected_member
      smsCodeState.setSMS('123456');

      // should be valid
      expect(key.currentState!.isFormValid, true);
      // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }


      // Check that the submit button is rendered
      TestUtils.widgetExistsByType(RecActionButton);

      // Get hold of the button
      var button = find.byType(RecActionButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(onCodeResult, '123456');
    });
  });
}
