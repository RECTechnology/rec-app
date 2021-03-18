import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/Modals/PinModal.dart';
import 'package:rec/Lang/AppLocalizations.dart';
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
  Widget buildPageContent(
    BuildContext context,
    AppState appState,
    AppLocalizations localizations,
  ) {
    return IconButtonRec(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/login');
      },
      icon: Icon(Icons.translate),
    );
  }
}
