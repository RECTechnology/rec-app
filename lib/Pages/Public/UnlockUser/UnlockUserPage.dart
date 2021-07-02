import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Api/Services/public/UnlockUserService.dart';
import 'package:rec/Components/Forms/UnlockUserForm.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/TitleText.dart';
import 'package:rec/Entities/Forms/UnlockUserData.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Public/Login/Login.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class UnlockUserPage extends StatefulWidget {
  final String sms;

  UnlockUserPage({this.sms = ''});

  @override
  _UnlockUserPageState createState() => _UnlockUserPageState();
}

class _UnlockUserPageState extends State<UnlockUserPage> {
  final _formKey = GlobalKey<FormState>();

  UnlockUserData data = UnlockUserData(prefix: '+34');

  @override
  void initState() {
    super.initState();
    data.sms = widget.sms;
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: EmptyAppBar(context, backArrow: false, crossX: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: Paddings.pageNoTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topTexts(),
                _unlockUserForm(),
                SizedBox(height: 130),
                RecActionButton(
                  label: localizations.translate('UNLOCK'),
                  backgroundColor: Brand.primaryColor,
                  onPressed: () => _next(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topTexts() {
    return Column(
      children: [
        TitleText('UNLOCK_PASSWORD'),
        SizedBox(height: 16),
        CaptionText(
          'INTRODUCE_TO_UNLOCK',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 22),
      ],
    );
  }

  Widget _unlockUserForm() {
    return UnlockUserForm(
      formKey: _formKey,
      data: data,
      onChange: (data) {
        this.data = data;
      },
    );
  }

  void _next() async {

    var localizations = AppLocalizations.of(context);
    var userService = UnlockUserService();
    if (!_formKey.currentState.validate()) return;
    await EasyLoading.show();
    await userService.unlockUser(data).then((value) {
      if(Navigator.canPop(context)){
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                  dni: data.dni,
                )));

      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginPage(
              dni: data.dni,
            )));
      }

      EasyLoading.dismiss();
      RecToast.showSuccess(
          context, 
          localizations.translate('UNLOCK_USER_SUCCES'),
      );
    }).onError((error, stackTrace) {
       EasyLoading.dismiss();

      if(error.message == 'Wrong phone' || error.message == 'Wrong DNI' ) {
        RecToast.showError(context,'WRONG_PHONE_DNI' );
        return;
      }
      
      if(error.message == 'The sms code is invalid or has expired'){
        RecToast.showError(context,'WRONG_SMS' );
        return;
      }
      
      RecToast.showError(context,error.message );
    });
  }
}
