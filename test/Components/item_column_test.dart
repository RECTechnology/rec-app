import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ItemColumn.dart';

void main() {
  testWidgets('ItemRowTest', (WidgetTester tester) async {
    var itemColumn = ItemColumnRec(
      aligment: Alignment.center,
      children: [Text('hola'), Text('que tal?'), CircleAvatar()],
    );

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: itemColumn,
    )));

    var textList = find.byType(Text);
    var circleAvatarList = find.byType(CircleAvatar);

    expect(textList, findsNWidgets(2));
    expect(circleAvatarList, findsOneWidget);
  });
}
