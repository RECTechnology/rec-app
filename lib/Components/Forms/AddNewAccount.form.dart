import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/CifTextField.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/Entities/Forms/NewAccountData.dart';
import 'package:rec/Helpers/validators/validators.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

/// Form for requesting a prefix, phone and a DNI
class AddNewAccountForm extends StatefulWidget {
  final NewAccountData data;
  final GlobalKey<FormState> formKey;
  final ValueChanged<NewAccountData> onChange;

  const AddNewAccountForm({
    Key key,
    this.data,
    this.onChange,
    @required this.formKey,
  }) : super(key: key);

  @override
  AddNewAccountFormState createState() => AddNewAccountFormState();
}

class AddNewAccountFormState extends State<AddNewAccountForm> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var isPrivate = widget.data.isAccountPrivate;

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        child: Column(
          children: [
            RecTextField(
              capitalizeMode: TextCapitalization.sentences,
              initialValue: widget.data.name,
              needObscureText: false,
              placeholder: localizations.translate('NAME'),
              keyboardType: TextInputType.text,
              label: localizations.translate('NAME'),
              icon: Icon(
                isPrivate ? Icons.person : Icons.storefront_outlined,
                color: Brand.grayIcon,
              ),
              onChange: _setName,
              validator: Validators.isRequired,
            ),
            if (!isPrivate)
              CifTextField(
                initialValue: widget.data.cif,
                onChange: _setCif,
                validator: (cif) {
                  if (widget.data.hasError('cif')) {
                    return widget.data.getError('cif');
                  }
                  return Validators.validateCif(cif);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _onChange() {
    if (widget.onChange != null) {
      widget.onChange(widget.data);
    }
  }

  void _setName(name) {
    setState(() {
      widget.data.name = name;
    });

    _onChange();
  }

  void _setCif(cif) {
    setState(() {
      widget.data.cif = cif;
    });

    _onChange();
  }
}
