import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/CifTextField.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RegisterStepTwoForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final ValueChanged<RegisterData>? onChange;
  final RegisterData? registerData;

  const RegisterStepTwoForm({
    Key? key,
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
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 8),
            child: RecTextField(
              capitalizeMode: TextCapitalization.sentences,
              initialValue: widget.registerData!.companyName,
              needObscureText: false,
              placeholder: localizations!.translate('NAME'),
              keyboardType: TextInputType.text,
              label: localizations.translate('NAME'),
              icon: Icon(
                Icons.storefront_outlined,
                color: recTheme!.grayLight3,
              ),
              onChange: setCompanyName,
              validator: Validators.isRequired,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: CifTextField(
              initialValue: widget.registerData!.companyCif,
              onChange: setCIF,
              validator: (cif) {
                if (widget.registerData!.hasError('cif')) {
                  return widget.registerData!.getError('cif');
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
      widget.registerData!.companyName = companyName;
      widget.registerData!.clearError('companyName');
    });
  }

  void setCIF(String? cif) {
    setState(() {
      widget.registerData!.companyCif = cif;
      widget.registerData!.clearError('companyName');
    });
  }
}
