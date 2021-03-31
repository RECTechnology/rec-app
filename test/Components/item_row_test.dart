import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ItemRow.dart';

void main() {
  testWidgets('ItemRowTest', (WidgetTester tester) async {
    var itemRow = ItemRowRec(
      aligment: Alignment.center,
      children: [
        Text('Hellou'),
        Text('bols'),
        ElevatedButton(
          onPressed: null,
          child: null,
        )
      ],
    );

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: itemRow,
    )));

    var textList = find.byType(Text);
    var listButton = find.byType(ElevatedButton);

    expect(textList, findsNWidgets(2));
    expect(listButton, findsOneWidget);
  });
}
