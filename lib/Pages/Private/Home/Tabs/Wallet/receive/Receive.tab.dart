import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Lang/AppLocalizations.dart';

class ReceiveTab extends StatefulWidget {
  ReceiveTab({Key key}) : super(key: key);

  @override
  _ReceiveTabState createState() => _ReceiveTabState();
}

class _ReceiveTabState extends GenericRecViewScreen<ReceiveTab>
    with SingleTickerProviderStateMixin {
  @override
  Widget buildPageContent(
    BuildContext context,
    AppState appState,
    UserState userState,
    AppLocalizations localizations,
  ) {
    return Container(child: Text('Pay'));
  }
}
