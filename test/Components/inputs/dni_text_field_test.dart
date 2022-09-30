import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Inputs/text_fields/DniTextField.dart';
import 'package:rec/helpers/validators/validators.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('DniTextField works with invalid DNI', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var key = GlobalKey<DniTextFieldState>();
      var formKey = GlobalKey<FormState>();
      String? onChangedResult;

      var widget = Form(
        key: formKey,
        child: DniTextField(
          key: key,
          onChange: (value) {
            onChangedResult = value;
          },
          validator: (s) => Validators.verifyIdentityDocument(s!),
        ),
      );
      await tester.pumpWidget(
        await TestUtils.wrapPublicRoute(widget),
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

      expect(formKey.currentState!.validate(), false);

      // VALID DNI  //
      await tester.tap(widgetFinder);
      await tester.showKeyboard(widgetFinder);
      await tester.enterText(widgetFinder, '80008000k');

      await tester.pumpAndSettle();

      expect(onChangedResult, '80008000k');

      expect(formKey.currentState!.validate(), true);

      // VALID DNI (with whitespace) //

      await tester.tap(widgetFinder);
      await tester.showKeyboard(widgetFinder);
      await tester.enterText(widgetFinder, '80008000k ');

      await tester.pumpAndSettle();
    });
  });

  testWidgets('DniTextField works with valid DNI', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var key = GlobalKey<DniTextFieldState>();
      var formKey = GlobalKey<FormState>();
      String? onChangedResult;

      var widget = Form(
        key: formKey,
        child: DniTextField(
          key: key,
          onChange: (value) {
            onChangedResult = value;
          },
          validator: (s) => Validators.verifyIdentityDocument(s!),
        ),
      );
      await tester.pumpWidget(
        await TestUtils.wrapPrivateRoute(widget),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Enter text into field
      var widgetFinder = find.byType(DniTextField);
      await tester.tap(widgetFinder);
      await tester.showKeyboard(widgetFinder);
      await tester.enterText(widgetFinder, '80008000k');

      await tester.pumpAndSettle();

      expect(onChangedResult, '80008000k');

      expect(formKey.currentState!.validate(), true);
    });
  });

  testWidgets('DniTextField works with valid DNI with trailing space', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var key = GlobalKey<DniTextFieldState>();
      var formKey = GlobalKey<FormState>();
      String? onChangedResult;

      var widget = Form(
        key: formKey,
        child: DniTextField(
          key: key,
          onChange: (value) {
            onChangedResult = value;
          },
          validator: (s) => Validators.verifyIdentityDocument(s!),
        ),
      );
      await tester.pumpWidget(
        TestUtils.wrapInMaterialApp(widget),
      );
      await tester.pumpAndSettle();

      // Enter text into field
      var widgetFinder = find.byWidget(widget);
      await tester.tap(widgetFinder);
      await tester.showKeyboard(widgetFinder);
      await tester.enterText(widgetFinder, '80008000k ');

      await tester.pumpAndSettle();

      // The value emitted by the field, should be free of trailing whitespace
      expect(onChangedResult, '80008000k');

      expect(formKey.currentState!.validate(), true);
    });
  });
}
