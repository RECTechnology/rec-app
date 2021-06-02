import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/PasswordField.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Helpers/Validators.dart';

class SetPasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onChangeRePassword;
  final ValueChanged<String> onChangePassword;

  const SetPasswordForm({
    Key key,
    this.formKey,
    this.onChangeRePassword,
    this.onChangePassword,
  }) : super(key: key);

  @override
  SetPasswordFormState createState() {
    return SetPasswordFormState();
  }
}

class SetPasswordFormState extends State<SetPasswordForm> {
  RegisterData registerData = RegisterData(
    prefix: '+34',
    accountType: Account.TYPE_PRIVATE,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Form(
        key: widget.formKey,
        child: Container(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: PasswordField(
                validator: Validators.verifyPassword,
                color: Colors.blueAccent,
                onChange: widget.onChangeRePassword,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: PasswordField(
                validator: Validators.verifyPassword,
                color: Colors.blueAccent,
                onChange: widget.onChangeRePassword,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
