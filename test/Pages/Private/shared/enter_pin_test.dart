import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Shared/EnterPin.page.dart';
import 'package:rec/providers/user_state.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);
 
  testWidgets('EnterPin build correctly', (
    WidgetTester tester,
  ) async {
    var app = await TestUtils.wrapPrivateRoute(
      EnterPin(
        ifPin: (pin) => print('got pin $pin'),
      ),
      userState: UserState(
        RecSecureStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
    for (int i = 0; i < 5; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    TestUtils.widgetExistsByType(EnterPin);
  });
}
