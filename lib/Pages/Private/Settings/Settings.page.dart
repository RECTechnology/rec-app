import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends GenericRecViewScreen<SettingsPage> {
  _SettingsPageState() : super(title: 'Settings', hasAppBar: true);

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
    return Scaffold(
      body: Center(
        child: Text("Estoy en la pestaña de configuracion"),
      ),
    );

  }
}
