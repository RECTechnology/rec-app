import 'package:flutter/material.dart';
import 'package:rec/Components/Inputs/RecFilterButton.dart';
import 'package:rec/Components/Layout/horizontal_list_layout.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/pay_to_address.page.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/roles_definitions.dart';
import 'package:rec/helpers/BrowserHelper.dart';
import 'package:rec/providers/AppLocalizations.dart';
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
    final userState = UserState.of(context);
    final user = userState.user;
    final hasPermissionToPay = user!.hasRoles(RoleDefinitions.payButtonMap);
    final filterButtons = <RecFilterButton>[
      if (hasPermissionToPay)
        RecFilterButton(
          icon: Icons.call_made,
          label: 'PAY',
          margin: EdgeInsets.only(right: 8),
          onPressed: () => _payTo(context),
          backgroundColor: Brand.primaryColor,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      RecFilterButton(
        icon: Icons.assistant_direction,
        label: 'HOW_TO_GO',
        margin: EdgeInsets.only(right: 8),
        onPressed: _launchMapsUrl,
        backgroundColor: Colors.white,
      ),
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

  void _launchMapsUrl() {
    BrowserHelper.openGoogleMaps(account.latitude, account.longitude);
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
        builder: (c) => PayAddress(paymentData: paymentData),
      ),
    );
  }
}
