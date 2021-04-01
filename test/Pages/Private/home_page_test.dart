import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Private/Home/Home.page.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Home Page test build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(HomePage());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(HomePage);
    TestUtils.isTextPresent('Mapa');
  });
}
