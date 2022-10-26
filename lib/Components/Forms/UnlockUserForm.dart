import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/DniTextField.dart';
import 'package:rec/Components/Inputs/text_fields/PrefixPhoneField.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// Form for requesting a prefix, phone and a DNI
class UnlockUserForm extends StatefulWidget {
  final UnlockUserData data;
  final GlobalKey<FormState> formKey;
  final ValueChanged<UnlockUserData?>? onChange;

  const UnlockUserForm({
    Key? key,
    required this.data,
    this.onChange,
    required this.formKey,
  }) : super(key: key);

  @override
  _UnlockUserForm createState() => _UnlockUserForm();
}

class _UnlockUserForm extends State<UnlockUserForm> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return Form(
      key: widget.formKey,
      child: Container(
        child: Column(
          children: [
            DniTextField(
              color: Colors.blueAccent,
              onChange: (dni) {
                widget.onChange!(widget.data..dni = dni);
              },
              initialValue: widget.data.dni,
              validator: Validators.verifyIdentityDocument,
            ),
            PrefixPhoneField(
              prefix: widget.data.prefix,
              phone: widget.data.phone,
              prefixChange: (prefix) {
                widget.onChange!(widget.data..prefix = prefix);
              },
              phoneChange: (phone) {
                widget.onChange!(widget.data..phone = phone);
              },
            ),
            RecTextField(
              label: localizations!.translate('SMS_CODE'),
              keyboardType: TextInputType.text,
              needObscureText: false,
              onChange: (sms) {
                widget.onChange!(widget.data..sms = sms);
              },
              initialValue: widget.data.sms,
              validator: Validators.smsCode,
              icon: Icon(
                Icons.mail_outline,
                color: recTheme!.grayLight2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
