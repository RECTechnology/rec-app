import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/PasswordField.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/AppLocalizations.dart';

/// Form for changing user's password, used by [ChangedPasswordPage]
class ChangePasswordForm extends StatefulWidget {
  /// Controls how one widget replaces another widget in the tree.
  final GlobalKey<FormState>? formKey;

  /// Called when old password changed
  final ValueChanged<String>? onChangeOldPassword;

  /// Called when new password changed
  final ValueChanged<String>? onChangePassword;

  /// Called when new repassword changed
  final ValueChanged<String>? onChangeRePassword;

  const ChangePasswordForm({
    Key? key,
    this.formKey,
    this.onChangeOldPassword,
    this.onChangePassword,
    this.onChangeRePassword,
  }) : super(key: key);

  @override
  ChangePasswordFormState createState() {
    return ChangePasswordFormState();
  }
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Form(
      key: widget.formKey,
      child: Container(
        child: Column(
          children: [
            PasswordField(
              title: localizations!.translate('CURRENT_PASSWORD'),
              validator: Validators.verifyPassword,
              onChange: widget.onChangeOldPassword,
            ),
            SizedBox(height: 16),
            PasswordField(
              title: localizations.translate('NEW_PASSWORD'),
              validator: Validators.verifyPassword,
              onChange: widget.onChangePassword,
            ),
            SizedBox(height: 16),
            PasswordField(
              title: localizations.translate('REPEAT_PASSWORD'),
              placeholder: localizations.translate('REPEAT_PASSWORD'),
              validator: Validators.verifyPassword,
              onChange: widget.onChangeRePassword,
            ),
          ],
        ),
      ),
    );
  }
}
