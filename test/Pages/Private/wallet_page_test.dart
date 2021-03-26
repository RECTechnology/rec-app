import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Private/Settings/Settings.page.dart';
import 'package:rec/Pages/Private/Wallet/Wallet.page.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Settings Page test build correctly', (
      WidgetTester tester,
      ) async {
    var app = TestUtils.wrapPageWithLocalization(WalletPageRec());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(WalletPageRec);
    TestUtils.isTextPresent('Estoy en la pestaña Wallet');
  });
}
