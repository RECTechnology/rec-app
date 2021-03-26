import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ItemRow.dart';

void main(){
  testWidgets("ItemRowTest", (WidgetTester tester) async{

    var itemRow = ItemRowRec(children: [Text("Hellou"), Text("bols"),RaisedButton(onPressed: null)],aligment: Alignment.center);

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: itemRow,)));

    var textList = find.byType(Text);
    var listButton = find.byType(RaisedButton);

    // var aligment = find.byType(Alignment.center);

    expect(textList, findsNWidgets(2));
    expect(listButton, findsOneWidget);



  });
}