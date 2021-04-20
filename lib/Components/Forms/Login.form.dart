import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DniTextField.dart';
import 'package:rec/Components/Inputs/PasswordField.dart';
import 'package:rec/Components/LoggedInBeforeCard.dart';
import 'package:rec/Entities/Forms/LoginData.dart';
import 'package:rec/Helpers/VerifyDataRec.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(LoginData data) onChange;

  const LoginForm({
    Key key,
    this.formKey,
    this.onChange,
  }) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  LoginData loginData = LoginData();

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var savedUser = userState.savedUser;
    var hasSavedUser = userState.hasSavedUser();

    if (hasSavedUser) {
      setUsername(savedUser.username);
    }

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: () => widget.onChange(loginData),
      child: Column(
        children: [
          hasSavedUser
              ? LoggedInBeforeCard(
                  savedUser: savedUser,
                  onNotYou: () => onNotYou(userState),
                )
              : _dniField(),
          _passwordField(),
        ],
      ),
    );
  }

  Widget _dniField() {
    var localizations = AppLocalizations.of(context);
    return DniTextField(
      initialValue: loginData.username,
      onChange: setUsername,
      validator: (s) => localizations.translate(
        VerifyDataRec.verifyIdentityDocument(s),
      ),
    );
  }

  Widget _passwordField() {
    var localizations = AppLocalizations.of(context);
    return Padding(
      padding: Paddings.textField,
      child: PasswordField(
        initialValue: loginData.password,
        onChange: setPassword,
        validator: (s) => localizations.translate(
          VerifyDataRec.verifyPassword(s),
        ),
      ),
    );
  }

  void setUsername(String username) {
    setState(() => loginData.username = username);
  }

  void setPassword(String password) {
    setState(() => loginData.password = password);
  }

  void onNotYou(UserState userState) async {
    await userState.unstoreUser();
    setUsername('');
  }
}
