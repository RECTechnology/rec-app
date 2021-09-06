import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/DniTextField.dart';
import 'package:rec/Components/Inputs/text_fields/PrefixPhoneField.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/Entities/Forms/UnlockUserData.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

/// Form for requesting a prefix, phone and a DNI
class UnlockUserForm extends StatefulWidget {
  final UnlockUserData data;
  final GlobalKey<FormState> formKey;
  final ValueChanged<UnlockUserData> onChange;

  const UnlockUserForm({
    Key key,
    this.data,
    this.onChange,
    @required this.formKey,
  }) : super(key: key);

  @override
  _UnlockUserForm createState() => _UnlockUserForm();
}

class _UnlockUserForm extends State<UnlockUserForm> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return Form(
      key: widget.formKey,
      child: Container(
        child: Column(
          children: [
            DniTextField(
              color: Colors.blueAccent,
              onChange: (dni) {
                widget.onChange(widget.data..dni = dni);
              },
              initialValue: widget.data.dni,
              validator: Validators.verifyIdentityDocument,
            ),
            PrefixPhoneField(
              prefix: widget.data.prefix,
              phone: widget.data.phone,
              prefixChange: (prefix) {
                widget.onChange(widget.data..prefix = prefix);
              },
              phoneChange: (phone) {
                widget.onChange(widget.data..phone = phone);
              },
              phoneValidator: Validators.phoneVerification,
            ),
            RecTextField(
              label: localizations.translate('SMS_CODE'),
              keyboardType: TextInputType.text,
              needObscureText: false,
              onChange: (sms) {
                widget.onChange(widget.data..sms = sms);
              },
              initialValue: widget.data.sms,
              validator: Validators.smsCode,
              icon: Icon(
                Icons.mail_outline,
                color: Brand.grayLight2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
