import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class WalletFloatingActions extends StatefulWidget {
  final TextStyle labelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: Brand.grayDark,
  );
  final ValueNotifier<bool> isDialOpen;

  WalletFloatingActions({Key key, @required this.isDialOpen}) : super(key: key);

  @override
  WalletFloatingActionsState createState() => WalletFloatingActionsState();
}

class WalletFloatingActionsState extends State<WalletFloatingActions> {
  @override
  Widget build(BuildContext context) {
    return buildSpeedDial(context);
  }

  SpeedDial buildSpeedDial(BuildContext context) {
    var userState = UserState.of(context);
    var isPrivate = userState.user.selectedAccount.isPrivate();
    var accountTypeColor =
        Brand.getColorForAccount(userState.user.selectedAccount);
    var isLtabAccount = userState.account.isLtabAccount();

    var privateChildren = [
      buildSpeedDialChild(
        'PAY_QR',
        Icons.qr_code_scanner,
        context,
        bgColor: accountTypeColor,
        route: Routes.payQr,
      ),
      buildSpeedDialChild(
        'PAY_ACCOUNT_CONTACT',
        Icons.call_made,
        context,
        bgColor: accountTypeColor,
        route: Routes.payContactAccount,
      ),
      isLtabAccount
          ? null
          : buildSpeedDialChild(
              'RECEIVE_PAYMENT',
              Icons.call_received,
              context,
              bgColor: accountTypeColor,
              route: Routes.charge,
            ),
      isLtabAccount
          ? null
          : buildSpeedDialChild(
              'RECHARGE_RECS',
              Icons.credit_card,
              context,
              iconColor: Brand.grayDark,
              bgColor: Brand.defaultAvatarBackground,
              route: Routes.recharge,
            ),
    ];
    var companyChildren = [
      buildSpeedDialChild(
        'CHARGE',
        Icons.call_received,
        context,
        bgColor: accountTypeColor,
        route: Routes.charge,
      ),
      buildSpeedDialChild(
        'PAY_QR',
        Icons.qr_code_scanner,
        context,
        bgColor: accountTypeColor,
        route: Routes.payQr,
      ),
      buildSpeedDialChild(
        'PAY_ACCOUNT_CONTACT',
        Icons.call_made,
        context,
        bgColor: accountTypeColor,
        route: Routes.payContactAccount,
      ),
      buildSpeedDialChild(
        'RECHARGE_RECS',
        Icons.credit_card,
        context,
        iconColor: Brand.grayDark,
        bgColor: Brand.defaultAvatarBackground,
        route: Routes.recharge,
      ),
    ];

    return SpeedDial(
      marginEnd: 20,
      marginBottom: 20,
      childMarginBottom: 24,
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
      children: (isPrivate ? privateChildren : companyChildren)
          .where((element) => element != null)
          .toList(),
    );
  }

  SpeedDialChild buildSpeedDialChild(
    String label,
    IconData icon,
    BuildContext context, {
    Color bgColor = Brand.primaryColor,
    Color iconColor = Colors.white,
    String route,
  }) {
    var localization = AppLocalizations.of(context);

    return SpeedDialChild(
      child: Icon(
        icon,
        color: iconColor,
      ),
      backgroundColor: bgColor,
      labelWidget: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Text(
          localization.translate(label),
          style: widget.labelStyle.copyWith(fontWeight: FontWeight.w400),
        ),
      ),
      elevation: 0,
      onTap: () => {if (route != null) Navigator.of(context).pushNamed(route)},
    );
  }
}
