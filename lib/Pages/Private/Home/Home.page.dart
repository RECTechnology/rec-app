import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Providers/AppState.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends PageBaseState<HomePage> {
  _HomePageState() : super(title: 'Home');

  @override
  Widget buildPageContent(BuildContext context, AppState appState) {
    return Text('Home');
  }
}
