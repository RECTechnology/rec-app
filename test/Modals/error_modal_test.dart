


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ButtonRec.dart';


void functionForTesting(){
  print("Hellou");
}
void main(){

  testWidgets("ErrorModal TEST", (WidgetTester tester) async{


    var button = ButtonRec(text:Text("Login"),onPressed: functionForTesting);

    await tester.pumpWidget(MaterialApp(home: button));

    var text = find.byType(Text);
    var function = find.byType(Function);//No entiendo porque peta al buscar la funcion, ***investigar

    expect(text, findsOneWidget);
    expect(function, findsOneWidget);

  });

}
