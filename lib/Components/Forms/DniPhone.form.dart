import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DniTextField.dart';
import 'package:rec/Components/Inputs/PrefixPhoneField.dart';
import 'package:rec/Helpers/Validators.dart';

class DniPhoneData {
  String dni;
  String phone;
  String prefix;

  DniPhoneData({this.dni, this.phone, this.prefix});
}

class DniPhoneForm extends StatefulWidget {
  final DniPhoneData data;
  final Function(DniPhoneData) onChange;
  final GlobalKey<FormState> formKey;

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
