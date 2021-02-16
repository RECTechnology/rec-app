import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Providers/AppState.dart';

class GenericRecViewScreen extends StatefulWidget {

  final List<Widget>widgetList;


  GenericRecViewScreen({
    Key key,
    this.widgetList,
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
          Expanded(child:ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.widgetList.length,
            itemBuilder: (context,index){
              return ListTile(
                title: widget.widgetList[index],
              );
            },
          ) )

        ],
      ),
    );
     }
}
