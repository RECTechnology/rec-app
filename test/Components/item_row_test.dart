import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ItemRow.dart';

void main() {
  testWidgets('ItemRow test', (WidgetTester tester) async {
    var itemColumn = ItemRowRec(
      children: [Text('data'), Text('data'), Text('data'), Text('data')],
    );

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: itemColumn,
    )));
  });
}
