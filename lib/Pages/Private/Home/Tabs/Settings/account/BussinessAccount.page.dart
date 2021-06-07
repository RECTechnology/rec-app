import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/AccountsService.dart';
import 'package:rec/Components/ListTiles/SectionTitleTile.dart';
import 'package:rec/Components/Map/BussinessHeader.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';

import 'package:rec/Components/ListTiles/GeneralSettingsTile.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Helpers/Validators.dart';
import 'package:rec/Pages/Private/Shared/EditField.page.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class BussinessAccountPage extends StatefulWidget {
  BussinessAccountPage({Key key}) : super(key: key);

  @override
  _BussinessAccountPageState createState() => _BussinessAccountPageState();
}

class _BussinessAccountPageState extends State<BussinessAccountPage> {
  final AccountsService _accountsService = AccountsService();

  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var tiles = [
      SectionTitleTile('YOUR_BUSSINESS'),
      GeneralSettingsTile(
        title: userState.account.name ?? 'BUSSINESS_NAME',
        subtitle: 'BUSSINESS_NAME_DESC',
        onTap: _editName,
      ),
      Divider(height: 1),
      GeneralSettingsTile(
        title: Checks.isNotEmpty(userState.account.description)
            ? userState.account.description
            : 'BUSSINESS_DESCRIPTION',
        subtitle: 'BUSSINESS_DESCRIPTION_DESC',
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

    return Scaffold(
      backgroundColor: Brand.defaultAvatarBackground,
      appBar: EmptyAppBar(context, title: 'SETTINGS_BUSSINESS_ON_MAP'),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: BussinessHeader(
              userState.account,
              subtitle: Text(
                'CHANGE_IMAGE',
                style: TextStyle(
                  color: Brand.accentColor,
                ),
              ),
              avatarBadge: Positioned(
                bottom: -8,
                right: -4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkResponse(
                    onTap: () {
                      print('tappppped');
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Brand.accentColor,
                      ),
                      child: Icon(Icons.add_a_photo,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              thickness: 8,
              showTrackOnHover: true,
              radius: Radius.circular(3),
              child: ListView.builder(
                itemBuilder: (ctx, index) => tiles[index],
                // separatorBuilder: (ctx, index) => Divider(height: 1),
                itemCount: tiles.length,
              ),
            ),
          ),
        ],
      ),
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
    RecToast.showInfo(context, 'FEATURE_NOT_YET_AVAILABLE');
  }

  void _editField({
    String fieldName = 'FIELD',
    FormFieldValidator<String> validator = Validators.isRequired,
    String initialValue,
    IconData icon,
  }) async {
    var userState = UserState.of(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditFieldPage(
          initialValue: initialValue,
          fieldName: fieldName,
          icon: icon,
          validator: validator,
          onSave: (value) {
            _updateAccount(userState.account.id, {
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
      initialValue: userState.account.name,
    );
  }

  void _editDescription() async {
    var userState = UserState.of(context, listen: false);
    return _editField(
      fieldName: 'DESCRIPTION',
      icon: Icons.text_fields,
      initialValue: userState.account.description,
    );
  }

  void _updateAccount(
    String accountId,
    Map<String, dynamic> data,
  ) {
    Loading.show();
    _accountsService
        .updateAccount(accountId, data)
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
