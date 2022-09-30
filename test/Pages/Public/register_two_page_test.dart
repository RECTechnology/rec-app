import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Register Page Two test build correctly', (
    WidgetTester tester,
  ) async {
    var app = await TestUtils.wrapPublicRoute(
      RegisterTwo(
        registerData: RegisterData(accountType: Account.TYPE_PRIVATE),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(RegisterTwo);
  });
}
