import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/IconButton.dart';

void main() {
  testWidgets('IconButtonRec click works', (WidgetTester tester) async {
    var clicked = false;
    void functionForTesting() {
      clicked = true;
    }

    var icon = Icon(Icons.translate);
    var button = IconButtonRec(
      icon: icon,
      onPressed: functionForTesting,
    );



    // Comprobamos que se ha clicado el boton
  });
}
