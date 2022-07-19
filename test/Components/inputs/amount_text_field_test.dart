import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Inputs/text_fields/AmountTextField.dart';
import 'package:rec/helpers/validators/validators.dart';

import '../../test_utils.dart';

void main() {
  group('AmountTextField', () {
    testWidgets('build by default', (tester) async {
      await tester.runAsync(() async {
        final amountField = AmountTextField();
        await tester.pumpWidget(
          TestUtils.wrapPublicWidget(amountField),
        );

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();

        TestUtils.widgetExists(amountField);
      });
    });

    testWidgets('initialValue', (tester) async {
      await tester.runAsync(() async {
        final amountField = AmountTextField(initialValue: '23', label: 'test');

        await tester.pumpWidget(TestUtils.wrapPublicWidget(amountField));

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();

        final textFormField = tester.firstWidget(find.byType(TextFormField)) as TextFormField;
        expect(textFormField.initialValue, '23');
      });
    });

    testWidgets('set controller correctly', (tester) async {
      await tester.runAsync(() async {
        final amountField = AmountTextField(
          controller: TextEditingController(text: '23'),
        );

        await tester.pumpWidget(TestUtils.wrapPublicWidget(amountField));

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();

        final textFormField = tester.firstWidget(find.byType(TextFormField)) as TextFormField;
        expect(textFormField.controller?.text, '23');
      });
    });

    testWidgets('disables correctly', (tester) async {
      await tester.runAsync(() async {
        final amountField = AmountTextField(
          controller: TextEditingController(text: '23'),
          enabled: false,
        );

        await tester.pumpWidget(TestUtils.wrapPublicWidget(amountField));

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();

        final textFormField = tester.firstWidget(find.byType(TextFormField)) as TextFormField;
        expect(textFormField.enabled, false);
      });
    });

    testWidgets('validates correctly', (tester) async {
      await tester.runAsync(() async {
        final amountField = AmountTextField(
          initialValue: '23',
          validator: Validators.maxAmount(10),
        );
        final formKey = GlobalKey<FormState>();
        final form = Form(child: amountField, key: formKey);

        await tester.pumpWidget(TestUtils.wrapPublicWidget(form));

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();

        final valid = formKey.currentState!.validate();
        expect(valid, false);

        // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
        for (int i = 0; i < 5; i++) {
          await tester.pump(Duration(seconds: 1));
        }

        final emailErrorFinder = find.text('Importe máximo excedido');

        expect(emailErrorFinder, findsOneWidget);
      });
    });
  });
}
