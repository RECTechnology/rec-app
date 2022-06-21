import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/roles_definitions.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';

class WalletFloatingActions extends StatefulWidget {
  final TextStyle labelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: Brand.grayDark,
  );
  final ValueNotifier<bool> isDialOpen;

  WalletFloatingActions({Key? key, required this.isDialOpen}) : super(key: key);

  @override
  WalletFloatingActionsState createState() => WalletFloatingActionsState();
}

class WalletFloatingActionsState extends State<WalletFloatingActions> {
  @override
  Widget build(BuildContext context) {
    return buildSpeedDial();
  }

  Widget buildSpeedDial() {
    final userState = UserState.of(context);
    final campaignProvider = CampaignProvider.of(context);
    final account = userState.account;
    final user = userState.user;
    final cultureCampaign = campaignProvider.getCampaignByCode(env.CMP_CULT_CODE);

    final isPrivate = account!.isPrivate();
    final accountTypeColor = Brand.getColorForAccount(account);
    final isLtabAccount = account.isLtabAccount();
    final isCultureAccount = account.isCampaignAccount(env.CMP_CULT_CODE);

    final hasPermissionToRecharge = user!.hasRoles(RoleDefinitions.rechargeRoles);
    final hasPermissionToPay = user.hasRoles(RoleDefinitions.payButton);
    final hasPermissionToPayQr = user.hasRoles(RoleDefinitions.payQrButton);
    final hasPermissionToCharge = user.hasRoles(RoleDefinitions.chargeButton);

    final isCultureCampaignActive =
        cultureCampaign != null && cultureCampaign.isStarted() && !cultureCampaign.isFinished();
    final rechargeRoute =
        (isCultureAccount || !isCultureCampaignActive) ? Routes.recharge : Routes.selectRecharge;

    final privateChildren = [
      if (hasPermissionToPay)
        buildSpeedDialChild(
          'PAY_QR',
          Icons.qr_code_scanner,
          context,
          bgColor: accountTypeColor,
          route: Routes.payQr,
        ),
      if (hasPermissionToPayQr)
        buildSpeedDialChild(
          'PAY_ACCOUNT_CONTACT',
          Icons.call_made,
          context,
          bgColor: accountTypeColor,
          route: Routes.payContactAccount,
        ),
      if (!isLtabAccount && hasPermissionToCharge)
        buildSpeedDialChild(
          'RECEIVE_PAYMENT',
          Icons.call_received,
          context,
          bgColor: accountTypeColor,
          route: Routes.charge,
        ),
      if (!isLtabAccount && hasPermissionToRecharge)
        buildSpeedDialChild(
          'RECHARGE_RECS',
          Icons.credit_card,
          context,
          iconColor: Brand.grayDark,
          bgColor: Brand.defaultAvatarBackground,
          route: rechargeRoute,
        ),
    ];

    final companyChildren = [
      if (hasPermissionToCharge)
        buildSpeedDialChild(
          'CHARGE',
          Icons.call_received,
          context,
          bgColor: accountTypeColor,
          route: Routes.charge,
        ),
      if (hasPermissionToPayQr)
        buildSpeedDialChild(
          'PAY_QR',
          Icons.qr_code_scanner,
          context,
          bgColor: accountTypeColor,
          route: Routes.payQr,
        ),
      if (hasPermissionToPay)
        buildSpeedDialChild(
          'PAY_ACCOUNT_CONTACT',
          Icons.call_made,
          context,
          bgColor: accountTypeColor,
          route: Routes.payContactAccount,
        ),
      if (hasPermissionToRecharge)
        buildSpeedDialChild(
          'RECHARGE_RECS',
          Icons.credit_card,
          context,
          iconColor: Brand.grayDark,
          bgColor: Brand.defaultAvatarBackground,
          route: rechargeRoute,
        ),
    ];

    final List<SpeedDialChild?> items = (isPrivate ? privateChildren : companyChildren);

    if (items.isEmpty) return SizedBox.shrink();

    return SpeedDial(
      openCloseDial: widget.isDialOpen,
      animationSpeed: 150,
      buttonSize: 60,
      icon: Icons.multiple_stop,
      activeIcon: Icons.close,
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      visible: true,
      curve: Curves.linear,
      overlayColor: Colors.white,
      overlayOpacity: 0.9,
      backgroundColor: accountTypeColor,
      foregroundColor: Colors.white,
      elevation: 0,
      children: items as List<SpeedDialChild>,
    );
  }

  SpeedDialChild buildSpeedDialChild(
    String label,
    IconData icon,
    BuildContext context, {
    Color bgColor = Brand.primaryColor,
    Color iconColor = Colors.white,
    String? route,
  }) {
    return SpeedDialChild(
      child: Icon(
        icon,
        color: iconColor,
      ),
      backgroundColor: bgColor,
      labelWidget: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: LocalizedText(
          label,
          style: widget.labelStyle.copyWith(fontWeight: FontWeight.w400),
        ),
      ),
      elevation: 0,
      onTap: () {
        if (route != null) Navigator.of(context).pushNamed(route);
      },
    );
  }
}
