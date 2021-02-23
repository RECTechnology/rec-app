import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Providers/AppState.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends GenericRecViewScreen<HomePage> {
  _HomePageState() : super(title: 'Home', hasAppBar: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPageContent(BuildContext context, AppState appState) {
    return IconButtonRec(
      button: ButtonRec(
        text: Text("Hellou", style: TextStyle(color: Colors.black)),
        onPressed: logingTester,
      ),
      icon: Icon(Icons.translate),
    );
  }

  void logingTester() {
    print("Loging...");
  }
}