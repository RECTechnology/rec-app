import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/add_offer.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AddOfferPage extends StatefulWidget {
  AddOfferPage({Key? key}) : super(key: key);

  @override
  _AddOfferPageState createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  final _offerService = OffersService(env: env);
  final _addOfferFormKey = GlobalKey<FormState>();
  var _newOffer = CreateOfferData();

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return FormPageLayout(
      appBar: EmptyAppBar(context, title: 'ADD_OFFER'),
      form: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: AddOfferForm(
          data: _newOffer,
          formKey: _addOfferFormKey,
          onChange: _offerChanged,
        ),
      ),
      submitButton: RecActionButton(
        label: 'PUBLISH',
        backgroundColor: recTheme!.primaryColor,
        onPressed: _publishOffer,
      ),
    );
  }

  void _offerChanged(CreateOfferData newOffer) {
    setState(() {
      _newOffer = newOffer;
    });
  }

  void _publishOffer() async {
    if (!_addOfferFormKey.currentState!.validate()) return;

    await Loading.show();

    await _offerService.createOffer(_newOffer).then(_offerCreated).catchError(_offerError);

    await Loading.dismiss();
  }

  void _offerCreated(resp) {
    Navigator.of(context).pop(resp);
  }

  void _offerError(err) {
    RecToast.showError(context, err.toString());
  }
}
