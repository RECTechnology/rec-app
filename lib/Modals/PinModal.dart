import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rec/Modals/GenericModal.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PinModal extends GenericModal {
  final Text title;
  final Text content;
  final BuildContext context;
  final int requieredNumber;

  int pin;
  final TextEditingController myController;

  var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.transparent));

  PinModal(
      {this.title,
      this.context,
      this.content,
      this.requieredNumber,
      this.myController})
      : super(
            content: content,
            title: title,
            widget: Container(
                margin:
                    EdgeInsets.fromLTRB(15, 0, 15, 0), //Left,Top,Right,Bottom,
                width: 400,
                height: 150,
                child: PinCodeTextField(
                  controller: myController,
                  appContext: context,
                  length: requieredNumber,
                  onChanged: (value) {
                    print(value);
                  },
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveColor: Colors.black,
                      activeColor: Colors.green,
                      selectedColor: Colors.greenAccent),
                  onCompleted: (value) {
                    if (value.length == requieredNumber) {
                      print("ValidValue");
                    } else {
                      print("InvalidValue");
                    }
                  },
                )));

  void showDialog() {
    super.showAlertDialog(context);
  }

  void closeModal() {
    super.closeDialog(context);
  }

  int getValue() {
    return int.parse(myController.text);
  }
}
