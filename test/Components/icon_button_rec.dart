


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';

import 'button_rec_test.dart';


void functionForTesting(){
  print("Hellou");
}
void main(){

  testWidgets("IconButtonRec test", (WidgetTester tester) async{

    Icon icon = Icon(Icons.translate);
    ButtonRec buttonRec = ButtonRec(onPressed: functionForTesting,text: "Hellou",);
    var iconButton = IconButtonRec(icon: icon,button: buttonRec,);

    await tester.pumpWidget(MaterialApp(home: iconButton));

    var iconTest = find.byType(Icon);
    var function = find.byType(Function);//Sigue sin detectar la funcion pero la funcion si que esta funcionando

    expect(iconTest, findsOneWidget);
    expect(function, findsOneWidget);

  });

}
