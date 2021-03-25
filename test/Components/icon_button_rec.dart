import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/IconButton.dart';

void main() {
  testWidgets("IconButtonRec test", (WidgetTester tester) async {
    var clicked = false;
    void functionForTesting() {
      clicked = true;
    }

    Icon icon = Icon(Icons.translate);
    var iconButton = IconButtonRec(
      icon: icon,
      onPressed: functionForTesting,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: iconButton,
        ),
      ),
    );
    await tester.tap(find.byWidget(iconButton));

    expect(clicked, true);
  });
}
