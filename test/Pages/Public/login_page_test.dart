import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Public/Login.page.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Login Page test build correctly', (WidgetTester tester) async {
    var app = TestUtils.wrapPublicRoute(LoginPage());

    await tester.pumpWidget(app);

    // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
    await tester.pumpAndSettle();

    // comprueba que haya una instanncia de LoginPage visible
    TestUtils.widgetExistsByType(LoginPage);
  });
}
