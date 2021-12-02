import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/CifTextField.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Helpers/validators/validators.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class RegisterStepTwoForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<RegisterData> onChange;
  final RegisterData registerData;

  const RegisterStepTwoForm({
    Key key,
    this.formKey,
    this.onChange,
    this.registerData,
  }) : super(key: key);

  @override
  RegisterStepOneFoTwotate createState() {
    return RegisterStepOneFoTwotate();
  }
}

class RegisterStepOneFoTwotate extends State<RegisterStepTwoForm> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 8),
            child: RecTextField(
              capitalizeMode: TextCapitalization.sentences,
              initialValue: widget.registerData.companyName,
              needObscureText: false,
              placeholder: localizations.translate('NAME'),
              keyboardType: TextInputType.text,
              label: localizations.translate('NAME'),
              icon: Icon(
                Icons.storefront_outlined,
                color: Brand.grayIcon,
              ),
              onChange: setCompanyName,
              validator: Validators.isRequired,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: CifTextField(
              initialValue: widget.registerData.companyCif,
              onChange: setCIF,
              validator: (cif) {
                if (widget.registerData.hasError('cif')) {
                  return widget.registerData.getError('cif');
                }
                return Validators.validateCif(cif);
              },
            ),
          ),
        ],
      ),
    );
  }

  void setCompanyName(String companyName) {
    setState(() {
      widget.registerData.companyName = companyName;
      widget.registerData.clearError('companyName');
    });
  }

  void setCIF(String cif) {
    setState(() {
      widget.registerData.companyCif = cif;
      widget.registerData.clearError('companyName');
    });
  }
}
