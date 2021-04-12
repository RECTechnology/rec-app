import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Public/ChangePassword/ChangePasswordPage.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('ChangePasswordPage test build correctly', (
      WidgetTester tester,
      ) async {
    var app = TestUtils.wrapPrivateRoute(ChangePasswordPage());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(ChangePasswordPage);
  });
}
