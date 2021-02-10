import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends PageBaseState<HomePage> {
  _HomePageState() : super(title: 'Home');

  @override
  Widget buildPageContent(context) {
    return Text('Home');
  }
}
