import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Components/ItemColumn.dart';
import 'package:rec/Providers/AppState.dart';

class GenericRecViewScreen extends StatefulWidget {

  final List<Widget>widgetList;
  final AppBar appBar;
  final Form form;


  GenericRecViewScreen({
    Key key,
    this.widgetList,
    this.appBar,
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
      appBar: widget.appBar,
      body: Column(
        children: <Widget>[
          ItemColumn(children: widget.widgetList,)//le implemento el ItemColumn porque al final es lo mismo , una lista que se visualiza dentro de un contenedor asi que para reducir codigo

        ],
      ),
    );
  }

  void comeBack(){
    //en caso de necessitar un boton o un floatingButton con una flecha que vuelva a tras o algo asi
  }



}
