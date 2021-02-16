import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Lang/AppLocalizations.dart';
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
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context).translate("BOLSA")),
      ),
      body:IconButtonRec(button: ButtonRec(text:Text("Hellou"),onPressed: logingTester,),icon: Icon(Icons.translate),)//LoadingButton(text: "Hellou",onPressed: logingTester,isLoading: true,)//SpinKit(size: 50,)// ButtonRec(text: "Loading",onPressed: logingTester,)//LoadingButton(text: "Hellou",onPressed: logingTester,isLoading: true,)//SpinKit(size: 50,)//CircleAvatarRec(imageUrl: "https://picsum.photos/250?image=9",)//LoginButton(text: "Login",onPressed: logingTester,isLoading: false,),CircleAvatarRec(imageUrl: "https://picsum.photos/250?image=9",)

    );

  }

  void logingTester(){
    print("Loging...");
  }
}

