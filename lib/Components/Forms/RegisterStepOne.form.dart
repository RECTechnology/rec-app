import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/DniTextField.dart';
import 'package:rec/Components/Inputs/text_fields/PasswordField.dart';
import 'package:rec/Components/Inputs/text_fields/PrefixPhoneField.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/RegisterData.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Providers/AppLocalizations.dart';

class RegisterStepOneForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<RegisterData> onChange;

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
          SizedBox(height: 32),
          PrefixPhoneField(
            prefix: registerData.prefix,
            phone: registerData.phone,
            prefixChange: setPrefix,
            phoneChange: setPhone,
            phoneValidator: (phone) => registerData.hasError('phone')
                ? registerData.getError('phone')
                : localizations.translate(
                    Validators.phoneVerification(phone),
                  ),
          ),
          DniTextField(
            onChange: setDni,
            validator: (dni) => registerData.hasError('dni')
                ? registerData.getError('dni')
                : localizations.translate(
                    Validators.verifyIdentityDocument(dni),
                  ),
          ),
          PasswordField(
            onChange: setPassword,
            validator: (password) => registerData.hasError('password')
                ? registerData.getError('password')
                : localizations.translate(
                    Validators.verifyPassword(password),
                  ),
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
