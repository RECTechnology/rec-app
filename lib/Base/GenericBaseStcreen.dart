import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/ItemColumn.dart';
import 'package:rec/Providers/AppState.dart';

class GenericRecBaseScreen extends StatefulWidget {
  final List<Widget> widgetList;
  final bool hasAppBar;
  final bool canGoBack;
  final String title;
  final String color;
  final Widget menu;
  final Form form;

  GenericRecBaseScreen(
      {Key key,
      this.hasAppBar,
      this.canGoBack,
      this.title,
      this.color,
      this.menu,
      this.widgetList,
      this.form})
      : super(key: key);

  @override
  _GenericRecBaseScreenState createState() => _GenericRecBaseScreenState();
}

class _GenericRecBaseScreenState extends PageBaseState<GenericRecBaseScreen> {
  _GenericRecBaseScreenState() : super(title: 'Login');

  AppBar createAppBar() {
    if (widget.canGoBack) {
      return AppBar(
        title: Text(widget.title),
        actions: [
          IconButtonRec(
            button: ButtonRec(
              onPressed: comeBack,
            ),
            icon: Icon(Icons.arrow_back),
          ),
          widget.menu,
        ],
      );
    } else {
      return AppBar(
        title: Text(widget.title),
        actions: [
          widget.menu,
        ],
      );
    }
  }

  @override
  Widget buildPageContent(BuildContext context, AppState appState) {
    Scaffold buildWhitAppBar = Scaffold(
      appBar: createAppBar(),
      body: Column(
        children: <Widget>[
          ItemColumn(
            children: widget.widgetList,
          )
          //le implemento el ItemColumn porque al final es lo mismo , una lista que se visualiza dentro de un contenedor asi que para reducir codigo
        ],
      ),
    );

    Scaffold buildWhitoutAppBar = Scaffold(
      body: Column(
        children: <Widget>[
          ItemColumn(
            children: widget.widgetList,
          )
          //le implemento el ItemColumn porque al final es lo mismo , una lista que se visualiza dentro de un contenedor asi que para reducir codigo
        ],
      ),
    );
    return widget.hasAppBar ? buildWhitAppBar : buildWhitoutAppBar;
  }

  void comeBack() {
    //en caso de necessitar un boton o un floatingButton con una flecha que vuelva a tras o algo asi
  }
}
