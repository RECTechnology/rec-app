import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/Map.page.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Map Page test build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(MapPage());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(MapPage);
  });
}
