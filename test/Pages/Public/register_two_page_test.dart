import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('RegisterTwo test build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPublicRoute(RegisterTwo());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(RegisterTwo);
  });
}
