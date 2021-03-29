import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ItemColumn.dart';
import 'package:rec/Components/ItemRow.dart';

void main(){
  testWidgets("ItemRowTest", (WidgetTester tester) async{

    var itemColumn = ItemColumnRec(children: [Text("hola"), Text("que tal?"),CircleAvatar()],aligment: Alignment.center);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: itemColumn,)));

    var textList = find.byType(Text);
    var circleAvatarList = find.byType(CircleAvatar);

    // var aligment = find.byType(Alignment.center);

    expect(textList, findsNWidgets(2));
    expect(circleAvatarList, findsOneWidget);
  });
}

