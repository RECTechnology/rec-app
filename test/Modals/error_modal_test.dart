import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Modals/PinModal.dart';

void functionForTesting() {
  print("Hellou");
}

void main() {
  testWidgets("ErrorModal TEST", (WidgetTester tester) async {
    var modal = PinModal(
        title: Text("Enter the pin"),
        content: Text("Please enter your pin acount"),
        requieredNumber: 5,
        myController: TextEditingController());

    //  await tester.pumpWidget(MaterialApp(home: Scaffold(body: modal.showDialog(),)));//como puedo comprobar una funcion que da un modal si para activarlo necessito un boton y tambien hace falta un context que no tengo

    var text = find.byType(Text);
    var function = find.byType(
        Function); //No entiendo porque peta al buscar la funcion, ***investigar

    expect(text, findsOneWidget);
    expect(function, findsOneWidget);
  });
}
