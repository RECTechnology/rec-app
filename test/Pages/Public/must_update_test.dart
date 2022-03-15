import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Public/MustUpdate.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('MustUpdate test build correctly', (WidgetTester tester) async {
    var app = await TestUtils.wrapPrivateRoute(MustUpdate());

    await tester.pumpWidget(app);

    // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
    await tester.pumpAndSettle();

    // comprueba que haya una instanncia de LoginPage visible
    TestUtils.widgetExistsByType(MustUpdate);
  });
}
