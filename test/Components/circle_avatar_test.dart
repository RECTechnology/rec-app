import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';

import '../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('CircleAvatar with network image', (WidgetTester tester) async {
    var circleAvatar = CircleAvatarRec(
      imageUrl: 'https://asdasd.photos/250?image=9',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(
            child: circleAvatar,
          ),
        ),
      ),
    );

    TestUtils.widgetExists(circleAvatar);
  });

  testWidgets('CircleAvatar with name, sets initial uppercased', (
    WidgetTester tester,
  ) async {
    var circleAvatar = CircleAvatarRec(
      name: 'name',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(
            child: circleAvatar,
          ),
        ),
      ),
    );

    TestUtils.widgetExists(circleAvatar);
    TestUtils.isTextPresent('N');
  });
}
