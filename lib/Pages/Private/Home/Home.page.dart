import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Modals/PinModal.dart';
import 'package:rec/Providers/AppState.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends GenericRecViewScreen<HomePage> {
  _HomePageState() : super(title: 'Home', hasAppBar: true);
  var pin;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPageContent(BuildContext context, AppState appState) {
    var errorModal = PinModal(
      title: Text("Error 404"),
      content: Text("Page not found!"),
      context: context,
    );
    return IconButtonRec(
      function: () {
        Navigator.of(context).pushReplacementNamed('/login');
      },
      icon: Icon(Icons.translate),
    );
  }

  void logingTester() {
    print("Loging...");
  }
}
