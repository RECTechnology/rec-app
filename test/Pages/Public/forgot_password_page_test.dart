import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Public/forgot_password.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('ForgotPassword test build correctly', (WidgetTester tester) async {
    var app = await TestUtils.wrapPrivateRoute(
      ForgotPassword(dni: '80008000q'),
    );

    await tester.pumpWidget(app);

    // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
    await tester.pumpAndSettle();

    // comprueba que haya una instanncia de LoginPage visible
    TestUtils.widgetExistsByType(ForgotPassword);
  });
}
