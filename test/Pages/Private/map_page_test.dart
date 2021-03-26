import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Private/Wallet/Wallet.page.dart';
import 'package:rec/Pages/Private/Map/Map.page.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Map Page test build correctly', (
      WidgetTester tester,
      ) async {
    var app = TestUtils.wrapPageWithLocalization(MapPage());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(MapPage);
    TestUtils.isTextPresent('Estoy en la pestaña Mapa');
  });
}
