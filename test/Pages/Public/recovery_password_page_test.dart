import 'package:flutter_test/flutter_test.dart';

import '../../../lib/Pages/Public/RecoveryPassword.page.dart';
import '../../test_utils.dart';

void main() {
  testWidgets('RecoveryPasswordPage test build correctly', (
      WidgetTester tester,
      ) async {
    var app = TestUtils.wrapPrivateRoute(RecoveryPasswordPage());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(RecoveryPasswordPage);
  });
}
