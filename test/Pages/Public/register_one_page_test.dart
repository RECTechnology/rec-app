import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';

import '../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Register Page One test build correctly', (
    WidgetTester tester,
  ) async {
    var app = await TestUtils.wrapPrivateRoute(RegisterOne());

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(RegisterOne);
  });
}
