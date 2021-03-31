import 'package:flutter_test/flutter_test.dart';
import 'file:///C:/Users/VictorCurro/AndroidStudioProjects/rec_app_v2/lib/Pages/Public/Login/Login.page.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Login Page test build correctly', (WidgetTester tester) async {
    var app = TestUtils.wrapPageWithLocalization(LoginPage(false));

    // Esto basicamente, expone el widget al tester, lo inicia
    // await tester.pumpWidget(app);
    //
    // // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
    // await tester.pumpAndSettle();
    //
    // // comprueba que haya una instanncia de LoginPage visible
    // TestUtils.widgetExistsByType(LoginPage);

    // comprueba que haya un Text con el texto 'LOGIN'
 //   TestUtils.isTextPresent('LOGIN');
  });
}
