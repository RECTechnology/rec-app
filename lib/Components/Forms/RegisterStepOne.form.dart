import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/text_fields/DniTextField.dart';
import 'package:rec/Components/Inputs/text_fields/PasswordField.dart';
import 'package:rec/Components/Inputs/text_fields/PrefixPhoneField.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RegisterStepOneForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final ValueChanged<RegisterData>? onChange;

  const RegisterStepOneForm({
    Key? key,
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
        widget.onChange!(registerData);
      },
      child: Column(
        children: [
          SizedBox(height: 32),
          PrefixPhoneField(
            prefix: registerData.prefix,
            phone: registerData.phone,
            prefixChange: setPrefix,
            phoneChange: setPhone,
            phoneValidator: (phone) =>
                registerData.hasError('phone') ? registerData.getError('phone') : null,
          ),
          DniTextField(
            onChange: setDni,
            validator: (v) {
              if (registerData.hasError('dni')) return registerData.getError('dni');

              var validateRes = Validators.verifyIdentityDocument(v);
              return validateRes != null ? localizations!.translate(validateRes) : null;
            },
          ),
          PasswordField(
            onChange: setPassword,
            validator: (v) {
              if (registerData.hasError('password')) return registerData.getError('password');

              var validateRes = Validators.verifyPassword(v);
              return validateRes != null ? localizations!.translate(validateRes) : null;
            },
            // validator: (password) => registerData.hasError('password')
            //     ? registerData.getError('password')
            //     : localizations!.translate(
            //         Validators.verifyPassword(password),
            //       ),
          ),
        ],
      ),
    );
  }

  void setAccountType(String type) {
    setState(() {
      registerData.accountType = type;
    });
    widget.onChange!(registerData);
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
    widget.onChange!(registerData);
  }

  void setPrefix(String prefix) {
    setState(() => registerData.prefix = prefix.toString());
    widget.onChange!(registerData);
  }

  void setDni(String? dni) {
    setState(() {
      registerData.dni = dni;
      registerData.clearError('dni');
    });
    widget.onChange!(registerData);
  }

  void setPassword(String password) {
    setState(() {
      registerData.password = password;
      registerData.clearError('password');
    });
    widget.onChange!(registerData);
  }
}
