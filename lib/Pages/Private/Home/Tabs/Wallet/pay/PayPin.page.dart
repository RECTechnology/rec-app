import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Helpers/Formatting.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class PayPin extends StatefulWidget {
  final PaymentData data;

  final Function(String) onPin;

  const PayPin({
    Key key,
    @required this.data,
    @required this.onPin,
  }) : super(key: key);

  @override
  _PayPinState createState() => _PayPinState();
}

class _PayPinState extends State<PayPin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        backgroundColor: Brand.defaultAvatarBackground,
        color: Brand.grayDark,
        title: 'Pay to ' + widget.data.vendor.name,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: widget.data.amount,
            label: widget.data.concept,
            color: Brand.grayDark,
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);
    var content = localizations.translate(
      'SEND_PAYMENT',
      params: {
        'amount': Formatting.formatCurrency(widget.data.amount),
      },
    );

    return RequestPin(
      buttonContent: content,
      buttonWithArrow: false,
      ifPin: widget.onPin,
    );
  }
}
