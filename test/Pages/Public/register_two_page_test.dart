import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('Register Page Two test build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPublicRoute(
      RegisterTwo(
        registerData: RegisterData(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(RegisterTwo);
  });
}
