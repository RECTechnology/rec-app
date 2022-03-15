import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/PickImage.dart';
import 'package:rec/Components/Layout/ScrollableListLayout.dart';
import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/Scaffold/BussinessHeader.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Shared/EditField.page.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/validators/validators.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class BussinessAccountPage extends StatefulWidget {
  BussinessAccountPage({Key? key}) : super(key: key);

  @override
  _BussinessAccountPageState createState() => _BussinessAccountPageState();
}

class _BussinessAccountPageState extends State<BussinessAccountPage> {
  final AccountsService _accountsService = AccountsService(env: env);

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var hasDescription = Checks.isNotEmpty(userState.account!.description);
    var tiles = [
      SectionTitleTile('YOUR_BUSSINESS'),
      GeneralSettingsTile(
        title: userState.account!.name ?? 'BUSSINESS_NAME',
        subtitle: 'BUSSINESS_NAME_DESC',
        onTap: _editName,
      ),
      Divider(height: 1),
      GeneralSettingsTile(
        title: hasDescription ? userState.account!.description : 'BUSSINESS_DESCRIPTION',
        subtitle: hasDescription ? 'BUSSINESS_DESCRIPTION' : 'BUSSINESS_DESCRIPTION_DESC',
        onTap: _editDescription,
      ),
      Container(height: 16),
      SectionTitleTile('BUSSINESS_INFO'),
      GeneralSettingsTile(
        title: 'BUSSINESS_LOCATION',
        subtitle: 'BUSSINESS_LOCATION_DESC',
        onTap: _goToLocation,
      ),
      Divider(height: 1),
      GeneralSettingsTile(
        title: 'BUSSINESS_CONTACT',
        subtitle: 'BUSSINESS_CONTACT_DESC',
        onTap: _goToContact,
      ),
      Divider(height: 1),
      GeneralSettingsTile(
        title: 'BUSSINESS_SCHEDULE',
        subtitle: 'BUSSINESS_SCHEDULE_DESC',
        onTap: _goToSchedule,
      ),
      Container(height: 16),
      SectionTitleTile('BUSSINESS_SALES'),
      GeneralSettingsTile(
        title: 'BUSSINESS_OFFERS',
        subtitle: 'BUSSINESS_OFFERS_DESC',
        onTap: _goToOffers,
      ),
    ];

    return ScrollableListLayout(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'SETTINGS_BUSSINESS_ON_MAP'),
      header: Container(
        color: Colors.white,
        child: BussinessHeader(
          userState.account,
          subtitle: PickImage(
            onPick: _changePublicImage,
            title: 'IMAGE_PUBLIC',
            buttonLabel: 'UPDATE',
            hint: 'IMAGE_PUBLIC_DESC',
            padding: EdgeInsets.zero,
            child: LocalizedText(
              'CHANGE_IMAGE',
              style: TextStyle(
                color: Brand.accentColor,
              ),
            ),
          ),
          avatarBadge: Positioned(
            bottom: -8,
            right: -4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PickImage(
                onPick: _changeCompanyImage,
                title: 'IMAGE_DE_CUENTA',
                buttonLabel: 'UPDATE',
                hint: 'IMAGE_DE_CUENTA_DESC',
              ),
            ),
          ),
        ),
      ),
      children: tiles,
    );
  }

  void _goToLocation() {
    Navigator.pushNamed(context, Routes.settingsAccountLocation);
  }

  void _goToContact() {
    Navigator.pushNamed(context, Routes.settingsAccountContact);
  }

  void _goToSchedule() {
    Navigator.pushNamed(context, Routes.settingsAccountSchedule);
  }

  void _goToOffers() {
    Navigator.pushNamed(context, Routes.settingsAccountOffers);
  }

  void _changeCompanyImage(String link) {
    _updateAccount({
      'company_image': link,
    });
  }

  void _changePublicImage(String link) {
    _updateAccount({
      'public_image': link,
    });
  }

  void _editField({
    String fieldName = 'FIELD',
    FormFieldValidator<String> validator = Validators.isRequired,
    String? initialValue,
    IconData? icon,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: initialValue,
          fieldName: fieldName,
          icon: icon,
          validator: validator,
          onSave: (value) {
            _updateAccount({
              fieldName.toLowerCase(): value,
            });
          },
        ),
      ),
    );
  }

  void _editName() async {
    var userState = UserState.of(context, listen: false);

    return _editField(
      fieldName: 'NAME',
      icon: Icons.person,
      initialValue: userState.account!.name,
    );
  }

  void _editDescription() async {
    var userState = UserState.of(context, listen: false);
    return _editField(
      fieldName: 'DESCRIPTION',
      icon: Icons.text_fields,
      initialValue: userState.account!.description,
    );
  }

  void _updateAccount(Map<String, dynamic> data) {
    Loading.show();

    var userState = UserState.of(context, listen: false);
    _accountsService
        .updateAccount(userState.account!.id, data)
        .then(_updateOk)
        .catchError(_onError);
  }

  Future<void> _updateOk(c) async {
    var userState = UserState.of(context, listen: false);
    await userState.getUser();

    Navigator.pop(context);

    await Loading.dismiss();
    RecToast.showSuccess(context, 'UPDATED_OK');
  }

  void _onError(e) {
    Loading.dismiss();
    RecToast.showError(context, e.message);
  }
}
