import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/DniTextField.dart';
import 'package:rec/Components/Inputs/PasswordField.dart';
import 'package:rec/Components/Inputs/PrefixPhoneField.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Helpers/VerifyDataRec.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class RegisterStepOneForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(RegisterData data) onChange;

  const RegisterStepOneForm({
    Key key,
    this.formKey,
    this.onChange,
  }) : super(key: key);

  @override
  RegisterStepOneFormState createState() {
    return RegisterStepOneFormState();
  }
}

class RegisterStepOneFormState extends State<RegisterStepOneForm> {
  RegisterData registerData = RegisterData(
    prefix: '+34',
    accountType: Account.TYPE_PRIVATE,
  );

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: () {
        widget.onChange(registerData);
      },
      child: Column(
        children: [
          SizedBox(height: 42),
          PrefixPhoneField(
            prefix: registerData.prefix,
            phone: registerData.phone,
            prefixChange: setPrefix,
            phoneChange: setPhone,
            phoneValidator: (phone) => registerData.hasError('phone')
                ? registerData.getError('phone')
                : localizations.translate(
                    VerifyDataRec.phoneVerification(phone),
                  ),
          ),
          DniTextField(
            onChange: setDni,
            color: registerData.isAccountPrivate
                ? Brand.primaryColor
                : Brand.accentColor,
            validator: (dni) => registerData.hasError('dni')
                ? registerData.getError('dni')
                : localizations.translate(
                    VerifyDataRec.verifyIdentityDocument(dni),
                  ),
          ),
          PasswordField(
            validator: (password) => registerData.hasError('password')
                ? registerData.getError('password')
                : localizations.translate(
                    VerifyDataRec.verifyPassword(password),
                  ),
            color: registerData.isAccountPrivate
                ? Brand.primaryColor
                : Brand.accentColor,
          ),
        ],
      ),
    );
  }

  void setAccountType(String type) {
    setState(() {
      registerData.accountType = type;
    });
    widget.onChange(registerData);
  }

  void setToPrivate() {
    setAccountType(Account.TYPE_PRIVATE);
  }

  void setToCompany() {
    setAccountType(Account.TYPE_COMPANY);
  }

  void setPhone(String telephone) {
    setState(() {
      registerData.phone = telephone;
      registerData.clearError('phone');
    });
    widget.onChange(registerData);
  }

  void setPrefix(String prefix) {
    setState(() => registerData.prefix = prefix.toString());
    widget.onChange(registerData);
  }

  void setDni(String dni) {
    setState(() {
      registerData.dni = dni;
      registerData.clearError('dni');
    });
    widget.onChange(registerData);
  }

  void setPassword(String password) {
    setState(() {
      registerData.password = password;
      registerData.clearError('password');
    });
    widget.onChange(registerData);
  }
}
