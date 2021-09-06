import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Public/ForgotPassword.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('RecoveryPasswordPage test build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(ForgotPassword());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(ForgotPassword);
  });
}
