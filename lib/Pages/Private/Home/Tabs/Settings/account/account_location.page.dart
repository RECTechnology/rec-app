import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rec/Api/third-party/RecGeocoding.dart';
import 'package:rec/Components/Inputs/DropDown.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Inputs/text_fields/RecTextField.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/paddings.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AccountLocationPage extends StatefulWidget {
  AccountLocationPage({Key? key}) : super(key: key);

  @override
  _AccountLocationPageState createState() => _AccountLocationPageState();
}

class _AccountLocationPageState extends State<AccountLocationPage> {
  final List<String> streetTypes = [
    'alameda',
    'avenida',
    'bulevar',
    'calle',
    'camino',
    'carretera',
    'glorieta',
    'jardin',
    'parque',
    'paseo',
    'plaza',
    'poligono',
    'rambla',
    'ronda',
    'rua',
    'travesia',
    'urbanizacion',
    'via',
  ];

  final AccountsService _accountsService = AccountsService(env: env);
  final FormattedAddress _address = FormattedAddress();
  final _formKey = GlobalKey<FormState>();

  UserState? userState;

  @override
  Widget build(BuildContext context) {
    final account = UserState.of(context).account;
    final localizations = AppLocalizations.of(context);
    final recTheme = RecTheme.of(context);

    return Scaffold(
      appBar: EmptyAppBar(
        context,
        title: 'BUSSINESS_LOCATION',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.page,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CaptionText('BUSSINESS_LOCATION_DESC_LONG'),
                const SizedBox(height: 32),
                LocalizedText('STREET_TYPE'),
                const SizedBox(height: 8),
                DropDown(
                  title: localizations!.translate('STREET_TYPE'),
                  data: streetTypes,
                  current: account!.address!.streetType,
                  onSelect: (streetType) {
                    setState(() => {_address.streetType = streetType});
                  },
                ),
                const SizedBox(height: 24),
                RecTextField(
                  initialValue: account.address!.streetName,
                  label: localizations.translate('STREET_NAME'),
                  colorLabel: recTheme!.grayDark3,
                  validator: Validators.isRequired,
                  onChange: (streetName) {
                    setState(() => {_address.streetName = streetName});
                  },
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: RecTextField(
                        initialValue: account.address!.streetNumber,
                        label: localizations.translate('STREET_NUMBER'),
                        colorLabel: recTheme.grayDark3,
                        validator: Validators.isRequired,
                        onChange: (streetNumber) {
                          setState(
                            () => _address.streetNumber = streetNumber,
                          );
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RecTextField(
                        initialValue: account.address!.zip,
                        label: localizations.translate('ZIP'),
                        colorLabel: recTheme.grayDark3,
                        validator: Validators.isRequired,
                        onChange: (zip) {
                          setState(() => {_address.zip = zip});
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                RecActionButton(
                  label: 'UPDATE_APP',
                  onPressed: _update,
                  backgroundColor: recTheme.primaryColor,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    userState ??= UserState.of(context);
    super.didChangeDependencies();
  }

  void _geocodingError(e) {
    Loading.dismiss();
    RecToast.showError(context, 'LOCATION_NOT_FOUND');
  }

  void _gotGeocodingResult(
    List<Location> locations,
    FormattedAddress address,
  ) {
    var location = locations.first;
    var data = {
      'latitude': location.latitude,
      'longitude': location.longitude,
      ...address.toJson(),
    };

    _accountsService
        .updateAccount(userState!.account!.id, data)
        .then(_updatedLocation)
        .catchError(_onError);
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message ?? 'LOCATION_NOT_FOUND');
  }

  void _update() async {
    if (!_formKey.currentState!.validate()) return;

    await Loading.show();

    var account = UserState.of(context, listen: false).account;
    _address.streetType = _address.streetType ?? account!.address!.streetType;
    _address.streetName = _address.streetName ?? account!.address!.streetName;
    _address.streetNumber = _address.streetNumber ?? account!.address!.streetNumber;
    _address.zip = _address.zip ?? account!.address!.zip;

    await RecGeocoding.reverseGeocodeAddress(_address)
        .then((res) => _gotGeocodingResult(res, _address))
        .catchError(_geocodingError);
  }

  void _updatedLocation(res) {
    userState!.getUser();

    Loading.dismiss();
    RecToast.showSuccess(context, 'LOCATION_CHANGED_OK');
    Navigator.pop(context);
  }
}
