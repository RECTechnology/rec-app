import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Components/ItemColumn.dart';
import 'package:rec/Providers/AppState.dart';

class GenericRecViewScreen extends StatefulWidget {

  final List<Widget>widgetList;
  final Form form;


  GenericRecViewScreen({
    Key key,
    this.widgetList,
    this.form

  }) : super(key: key);


  @override
  _GenericRecViewScreenState createState() => _GenericRecViewScreenState();
}

class _GenericRecViewScreenState extends PageBaseState<GenericRecViewScreen> {
  _GenericRecViewScreenState() : super(title: 'Login');

  @override
  Widget buildPageContent(BuildContext context, AppState appState) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ItemColumn(children: widget.widgetList,)

        ],
      ),
    );
  }

  void changeUserName(){
  }
  void changeLanguage(){

  }
  void changeAvatar(){

  }
  void changeEmail(){

  }
  void changePassword(){

  }
  void changeTheme(){

  }






}
