import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/RecTextField.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:
            EmptyAppBar(context, title: localizations.translate('EMAIL_ONLY')),
        body: SingleChildScrollView(
          child: Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 43.0),
                  child: Form(
                    key: _formKey,
                    child: RecTextField(
                      icon: Icon(Icons.mail_outline),
                      label: localizations.translate('EMAIL_ONLY'),
                      colorLabel: Brand.grayDark4,
                    ),
                  ),
                ),
                RecActionButton(
                  label: localizations.translate('UPDATE'),
                  backgroundColor: Brand.primaryColor,
                  icon: Icons.arrow_forward_ios_sharp,
                  onPressed: () => update(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void update() {}
}
