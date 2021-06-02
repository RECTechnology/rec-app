import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DniTextField.dart';
import 'package:rec/Components/Inputs/PrefixPhoneField.dart';
import 'package:rec/Entities/Forms/DniPhoneData.dart';
import 'package:rec/Helpers/Validators.dart';

/// Form for requesting a prefix, phone and a DNI
class DniPhoneForm extends StatefulWidget {
  final DniPhoneData data;
  final GlobalKey<FormState> formKey;
  final ValueChanged<DniPhoneData> onChange;

  const DniPhoneForm({
    Key key,
    this.data,
    this.onChange,
    @required this.formKey,
  }) : super(key: key);

  @override
  _DniPhoneForm createState() => _DniPhoneForm();
}

class _DniPhoneForm extends State<DniPhoneForm> {
  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}
