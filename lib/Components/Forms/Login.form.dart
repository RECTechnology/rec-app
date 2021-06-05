import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DniTextField.dart';
import 'package:rec/Components/Inputs/PasswordField.dart';
import 'package:rec/Components/Info/LoggedInBeforeCard.dart';
import 'package:rec/Entities/Forms/LoginData.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/PreferenceProvider.dart';
import 'package:rec/Providers/Preferences/PreferenceDefinitions.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';

/// Form for asking for loggin credentials, username & password
class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<LoginData> onChange;
  final ValueChanged<LoginData> onSubmitted;

  const LoginForm({
    Key key,
    this.formKey,
    this.onChange,
    this.onSubmitted,
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
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: LoggedInBeforeCard(
                    savedUser: savedUser,
                    onNotYou: () => onNotYou(),
                  ),
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
        Validators.verifyIdentityDocument(s),
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
          Validators.verifyPassword(s),
        ),
        onSubmitted: (s) {
          setPassword(s);
          widget.onSubmitted(loginData);
        },
      ),
    );
  }

  void setUsername(String username) {
    setState(() => loginData.username = username);
  }

  void setPassword(String password) {
    setState(() => loginData.password = password);
  }

  void onNotYou() async {
    var userState = UserState.of(context, listen: false);
    var preferences = PreferenceProvider.deaf(context);

    preferences.set(
      PreferenceKeys.showLtabCampaign,
      PreferenceDefinitions.showLtabCampaign.defaultValue,
    );
    await userState.unstoreUser();
    setUsername('');
  }
}
