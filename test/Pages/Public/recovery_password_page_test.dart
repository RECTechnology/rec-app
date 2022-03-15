import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Public/forgot_password.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('RecoveryPasswordPage test build correctly', (
    WidgetTester tester,
  ) async {
    var app = await TestUtils.wrapPrivateRoute(ForgotPassword());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(ForgotPassword);
  });
}
