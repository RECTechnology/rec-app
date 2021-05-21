import 'package:flutter/material.dart';
import 'package:rec/Components/Info/InfoSplash.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Helpers/BrowserHelper.dart';
import 'package:rec/Helpers/RecPlatformHelper.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/brand.dart';

class MustUpdate extends StatefulWidget {
  MustUpdate({Key key}) : super(key: key);

  @override
  _MustUpdateState createState() => _MustUpdateState();
}

class _MustUpdateState extends State<MustUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Brand.grayDark),
            onPressed: _rejectUpdate,
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
              InfoSplash(
                title: 'MUST_UPDATE_APP',
                subtitle: 'MUST_UPDATE_DESC',
                icon: Icons.get_app,
              ),
              Column(
                children: [
                  RecActionButton(
                    label: 'UPDATE_APP',
                    onPressed: _goToStore,
                    icon: Icons.get_app,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _goToStore() {
    var appState = AppState.of(context, listen: false);
    BrowserHelper.openMarketOrPlayStore(appState.packageName);
  }

  void _rejectUpdate() {
    RecPlatform.closeApp(context);
  }
}
