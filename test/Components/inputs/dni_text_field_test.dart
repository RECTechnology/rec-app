import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Inputs/text_fields/DniTextField.dart';
import 'package:rec/Helpers/validators/validators.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('DniTextField works with invalid DNI',
      (WidgetTester tester) async {
    var key = GlobalKey<DniTextFieldState>();
    var formKey = GlobalKey<FormState>();
    var onChangedResult;

    var widget = Form(
      key: formKey,
      child: DniTextField(
        key: key,
        onChange: (String value) {
          onChangedResult = value;
        },
        validator: (s) => Validators.verifyIdentityDocument(s),
      ),
    );
    await tester.pumpWidget(
      TestUtils.wrapPublicRoute(widget),
    );
    await tester.pumpAndSettle();

    // Test that widget has at least rendered
    TestUtils.widgetExists(widget);
    var widgetFinder = find.byWidget(widget);

    // INVALID DNI  //
    await tester.tap(widgetFinder);
    await tester.showKeyboard(widgetFinder);
    await tester.enterText(widgetFinder, 'invaliddni');

    await tester.pumpAndSettle();

    expect(onChangedResult, 'invaliddni');

    expect(formKey.currentState.validate(), false);

    // VALID DNI  //
    await tester.tap(widgetFinder);
    await tester.showKeyboard(widgetFinder);
    await tester.enterText(widgetFinder, '80008000k');

    await tester.pumpAndSettle();

    expect(onChangedResult, '80008000k');

    expect(formKey.currentState.validate(), true);

    // VALID DNI (with whitespace) //

    await tester.tap(widgetFinder);
    await tester.showKeyboard(widgetFinder);
    await tester.enterText(widgetFinder, '80008000k ');

    await tester.pumpAndSettle();

    // The value emitted by the field, should be free of trailing whitespace
    expect(onChangedResult, '80008000k');

    expect(formKey.currentState.validate(), true);
  });
}
