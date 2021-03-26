import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ButtonRec.dart';

void main() {
  testWidgets('ButtonRec click works', (WidgetTester tester) async {
    var clicked = false;
    void functionForTesting() {
      clicked = true;
    }

    var button = ButtonRec(
      textColor: Colors.white,
      backgroundColor:
      Colors.blueAccent,
      onPressed: functionForTesting,
      isButtonDisabled: false,
      text: Text('Login'),
    );


    await tester.pumpWidget(MaterialApp(home: button));
    await tester.tap(find.byWidget(button));

    // Comprobamos que se ha clicado el boton
    expect(clicked, true
    );
  });

  testWidgets('ButtonRec sets correct text', (WidgetTester tester) async {

    var button = ButtonRec(
      textColor: Colors.white,
      backgroundColor:
      Colors.blueAccent,
      isButtonDisabled: false,
      text: Text('Login'),
    );

    await tester.pumpWidget(MaterialApp(home: button));
    await tester.tap(find.byWidget(button));

    // Comprobamos que se muestra el texto
    expect(find.text('Login'), findsOneWidget);
  });
}