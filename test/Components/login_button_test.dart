


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ButtonRec.dart';


void functionForTesting(){
  print("Hellou");
}
void main(){

  testWidgets("LoginButon test", (WidgetTester tester) async{


    var loginButton = ButtonRec(text: "Login",onPressed: functionForTesting);
    
    await tester.pumpWidget(MaterialApp(home: loginButton));

    var text = find.byType(Text);


    expect(text, findsOneWidget);

  });
  
}
