import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Text/RecAmountText.dart';
import '../test_utils.dart';

void main() {
  testWidgets('RecAmountText works', (WidgetTester tester) async {
    var widget = RecAmountText(amount: 0.90);

    await tester.pumpWidget(await TestUtils.wrapPublicWidget(widget));
    await tester.pumpAndSettle();

    TestUtils.widgetExists(widget);

    final richTextWidget = tester.element(find.byType(RichText)).widget as RichText;
    var text = richTextWidget.text.toPlainText();

    expect(text, '0,90R');
  });
}
