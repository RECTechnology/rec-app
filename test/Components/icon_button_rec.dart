


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';



void functionForTesting(){
  print("Hellou");
}
void main(){

  testWidgets("IconButtonRec test", (WidgetTester tester) async{

    Icon icon = Icon(Icons.translate);
    var iconButton = IconButtonRec(icon: icon,function: functionForTesting,);

    await tester.pumpWidget(MaterialApp(home: iconButton));

    var iconTest = find.byType(Icon);
    var function = find.byType(Function);//Sigue sin detectar la funcion pero la funcion si que esta funcionando

    expect(iconTest, findsOneWidget);
    expect(function, findsOneWidget);

  });

}
