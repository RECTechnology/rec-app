import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/PasswordField.dart';
import 'package:rec/Components/Inputs/text_fields/RecPinInput.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/helpers/validators/validators.dart';

/// Form for changing pin, used by [ChangedPinPage]
class ChangePinForm extends StatefulWidget {
  /// Controls how one widget replaces another widget in the tree.
  final GlobalKey<FormState>? formKey;

  /// Called when pin changed
  final ValueChanged<String>? onChangePin;

  /// Called when repin changed
  final ValueChanged<String>? onChangeRePin;

  /// Called when password changed
  final ValueChanged<String>? onChangePassword;

  const ChangePinForm({
    Key? key,
    this.formKey,
    this.onChangePin,
    this.onChangeRePin,
    this.onChangePassword,
  }) : super(key: key);

  @override
  ChangePinFormState createState() {
    return ChangePinFormState();
  }
}

class ChangePinFormState extends State<ChangePinForm> {
  final FocusNode repinFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var labelStyle = theme.textTheme.subtitle1!.copyWith(
      fontWeight: FontWeight.w500,
      color: Brand.grayDark,
    );

    return Form(
      key: widget.formKey,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16.0),
              child: LocalizedText(
                'NEW_PIN',
                style: labelStyle,
              ),
            ),
            RecPinInput(
              fieldsCount: 4,
              autofocus: true,
              onChanged: widget.onChangePin,
              onSubmit: (v) {
                repinFocus.requestFocus();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16.0),
              child: LocalizedText(
                'NEW_REPIN',
                style: labelStyle,
              ),
            ),
            RecPinInput(
              onChanged: widget.onChangeRePin,
              focusNode: repinFocus,
              fieldsCount: 4,
              onSubmit: (v) {
                passwordFocus.requestFocus();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 16.0),
              child: PasswordField(
                focusNode: passwordFocus,
                title: 'PASSWORD',
                validator: Validators.verifyPassword,
                onChange: widget.onChangePassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
