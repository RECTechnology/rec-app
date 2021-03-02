import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Components/ButtonRec.dart';
import 'package:rec/Modals/PinModal.dart';
import 'package:rec/Providers/AppState.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends GenericRecViewScreen<HomePage> {
  _HomePageState() : super(title: 'Home', hasAppBar: true);
  var pin;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPageContent(BuildContext context, AppState appState) {
    var pinModal = PinModal(
        title: Text("Enter the pin"),
        content: Text("Please enter your pin acount"),
        context: context,
        requieredNumber: 5,
        myController: TextEditingController());

    void changePin() {
      pin = pinModal.getValue();
      setState(() {});
    }

    return Scaffold(
      body: Column(
        children: [
          IconButtonRec(
            button: ButtonRec(
              text: Text("Hellou", style: TextStyle(color: Colors.black)),
              onPressed: pinModal.showDialog,
            ),
            icon: Icon(Icons.translate),
          ),
          IconButtonRec(
            button: ButtonRec(
              text: Text("Hellou", style: TextStyle(color: Colors.black)),
              onPressed: changePin,
            ),
            icon: Icon(Icons.change_history),
          ),
          Text(pin == null
              ? "the top button is to insert a pin the bot button is to get it"
              : pin.toString())
        ],
      ),
    );
  }
}
