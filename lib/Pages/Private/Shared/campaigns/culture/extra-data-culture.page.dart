import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/culture-campaign-extra.data.dart';
import 'package:rec/Pages/Private/Shared/campaigns/culture/culture-extra-data.form.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/providers/user_state.dart';

class CultureExtraDataPage extends StatefulWidget {
  CultureExtraDataPage({Key? key}) : super(key: key);

  @override
  _CultureExtraDataStatePage createState() => _CultureExtraDataStatePage();
}

class _CultureExtraDataStatePage extends State<CultureExtraDataPage> {
  final _formKey = GlobalKey<FormState>();
  CultureExtraData data = CultureExtraData();

  initState() {
    super.initState();
    var userState = UserState.deaf(context);

    data.gender = userState.user!.gender;
    data.zipCode = userState.user!.zip;
    data.birthYear = DateTime.tryParse(userState.user!.birthDate ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
   
    return FormPageLayout(
      appBar: EmptyAppBar(context, title: 'REC_CULTURE'),
      header: LocalizedText('REC_CULTURE_DATA_INFO'),
      form: CultureExtraDataForm(
        data: data,
        formKey: _formKey,
        onChange: _formChanged,
      ),
      submitButton: RecActionButton(
        label: 'PARTICIPATE',
        backgroundColor: recTheme!.primaryColor,
        onPressed: data.isValid() ? _proceed : null,
      ),
    );
  }

  void _proceed() {
    if (!_formKey.currentState!.validate()) {
      RecToast.showError(context, 'INVALID_FORM');
      return;
    }

    Loading.show();
    var userState = UserState.deaf(context);
    userState.userService
        .updateKycUser(userState.user!.kycId, data.toJson())
        .then(_savedOk)
        .catchError(_onError);
  }

  void _savedOk(_) {
    Loading.dismiss();
    Navigator.pop(context, true);
  }

  void _onError(err) {
    Loading.dismiss();
    RecToast.showError(context, err.toString());
  }

  void _formChanged(CultureExtraData newData) {
    setState(() {
      data = newData;
    });
  }
}
