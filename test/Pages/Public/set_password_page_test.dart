import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Public/SetPassword/SetPassword.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('SetPasswordPage test build correctly', (WidgetTester tester) async {
    var app = await TestUtils.wrapPrivateRoute(
      SetPasswordPage(
        DniPhoneData(
          dni: '80008000q',
          phone: '666777888',
          prefix: '34',
        ),
        '123456',
      ),
    );

    await tester.pumpWidget(app);

    // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
    await tester.pumpAndSettle();

    // comprueba que haya una instanncia de LoginPage visible
    TestUtils.widgetExistsByType(SetPasswordPage);
  });
}
