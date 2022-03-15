import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/DniTextField.dart';
import 'package:rec/Components/Inputs/text_fields/PasswordField.dart';
import 'package:rec/Components/Info/LoggedInBeforeCard.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/PreferenceProvider.dart';
import 'package:rec/providers/preferences/PreferenceDefinitions.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// Form for asking for loggin credentials, username & password
class LoginForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final ValueChanged<LoginData>? onChange;
  final ValueChanged<LoginData>? onSubmitted;
  final String? initialDNI;

  const LoginForm({
    Key? key,
    this.formKey,
    this.onChange,
    this.onSubmitted,
    this.initialDNI,
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
      setUsername(savedUser!.username);
    }

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: () => widget.onChange!(loginData),
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
      initialValue: widget.initialDNI ?? loginData.username,
      onChange: setUsername,
      validator: (v) {
        var validateRes = Validators.verifyIdentityDocument(v);
        return validateRes != null ? localizations!.translate(validateRes) : null;
      },
    );
  }

  Widget _passwordField() {
    var localizations = AppLocalizations.of(context);
    return Padding(
      padding: Paddings.textField,
      child: PasswordField(
        initialValue: loginData.password,
        onChange: setPassword,
        validator: (v) {
          var validateRes = Validators.verifyPassword(v);
          return validateRes != null ? localizations!.translate(validateRes) : null;
        },
        onSubmitted: (s) {
          setPassword(s);
          widget.onSubmitted!(loginData);
        },
      ),
    );
  }

  void setUsername(String? username) {
    setState(() => loginData.username = username);
  }

  void setPassword(String password) {
    setState(() => loginData.password = password);
  }

  void onNotYou() async {
    var userState = UserState.of(context, listen: false);
    var preferences = PreferenceProvider.deaf(context);

    await preferences.set(
      PreferenceKeys.showLtabCampaign,
      PreferenceDefinitions.showLtabCampaign.defaultValue,
    );
    await preferences.set(
      PreferenceKeys.showCultureCampaign,
      PreferenceDefinitions.showCultureCampaign.defaultValue,
    );

    await userState.unstoreUser();
    setUsername('');
  }
}
