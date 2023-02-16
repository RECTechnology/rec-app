import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:rec/Components/Inputs/RecFilterButton.dart';
import 'package:rec/Components/Layout/horizontal_list_layout.dart';
import 'package:rec/Components/Modals/login_to_pay.modal.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/pay_to_address.page.dart';
import 'package:rec/config/roles_definitions.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/BrowserHelper.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class SummaryFilterButtons extends StatelessWidget {
  final Account account;

  const SummaryFilterButtons({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final userState = UserState.of(context);
    final user = userState.user;
    final hasPermissionToPay = user != null && user.hasRoles(RoleDefinitions.payButtonMap);
    final filterButtons = <RecFilterButton>[
      if (!hasPermissionToPay)
        RecFilterButton(
          icon: Icons.call_made,
          label: 'PAY',
          margin: EdgeInsets.only(right: 8),
          onPressed: () => _loginToPay(context),
          backgroundColor: recTheme!.primaryColor,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      if (hasPermissionToPay)
        RecFilterButton(
          icon: Icons.call_made,
          label: 'PAY',
          margin: EdgeInsets.only(right: 8),
          onPressed: () => _payTo(context),
          backgroundColor: recTheme!.primaryColor,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      RecFilterButton(
        icon: Icons.assistant_direction,
        label: 'HOW_TO_GO',
        margin: EdgeInsets.only(right: 8),
        onPressed: () => _launchMapsUrl(context),
        backgroundColor: Colors.white,
      ),
      if (account.phone?.isNotEmpty == true && account.phone?.length == 9)
        RecFilterButton(
          icon: Icons.phone,
          label: 'CALL',
          margin: EdgeInsets.only(right: 8),
          onPressed: _call,
          backgroundColor: Colors.white,
        ),
    ];

    return Container(
      height: 30 + 32.0,
      child: HorizontalList(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: filterButtons,
      ),
    );
  }

  void _launchMapsUrl(context) {
    openMapsSheet(context);
    // BrowserHelper.openGoogleMaps(account.latitude, account.longitude);
  }

  void _call() {
    BrowserHelper.openCallPhone(account.fullPhone);
  }

  void _payTo(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final paymentData = PaymentData(
      address: account.recAddress,
      amount: null,
      concept: localizations!.translate(
        'PAY_TO_NAME',
        params: {
          'name': account.name,
        },
      ),
      vendor: VendorData(name: account.name),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => PayAddressPage(paymentData: paymentData),
      ),
    );
  }

  _loginToPay(BuildContext context) {
    LoginToPayModal.open(context);
  }
  
  openMapsSheet(BuildContext context) async {
    try {
      final coords = Coords(account.latitude ?? 0, account.longitude ?? 0);
      final title = account.name ?? 'Map';
      final availableMaps = await MapLauncher.installedMaps;
      if (availableMaps.length == 1) {
        // If only 1 maps app is installed, open directly
        return availableMaps.first.showMarker(coords: coords, title: title);
      }

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LocalizedText(
                        'SELECT_MAPS_APP',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
