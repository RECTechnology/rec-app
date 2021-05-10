import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/wallet/TransactionsService.dart';
import 'package:rec/Components/PrivateRoute.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Entities/VendorData.ent.dart';
import 'package:rec/Helpers/RecPlatformHelper.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/AttemptPayment.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayAddress.page.dart';
import 'package:rec/Pages/Public/Login/Login.page.dart';
import 'package:rec/routes.dart';

class PayLink extends StatefulWidget {
  final PaymentData paymentData;

  PayLink({
    Key key,
    @required this.paymentData,
  }) : super(key: key);

  @override
  _PayLinkState createState() => _PayLinkState();
}

class _PayLinkState extends State<PayLink> {
  final TransactionsService transactionsService = TransactionsService();
  String error;

  @override
  void initState() {
    super.initState();
    if (widget.paymentData.address == null) {
      error = 'Invalid link';
      return;
    }
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: error != null ? Text(error) : SizedBox(),
    );
  }

  void _setup() async {
    await _ensureLoggedIn();

    var vendorData = await _getVendorDataFromAddress(widget.paymentData.address)
        .catchError(_showErrorToast);

    if (vendorData != null) {
      widget.paymentData.vendor = vendorData;
      var isPaymentDataComplete = widget.paymentData.isComplete();
      var page = isPaymentDataComplete
          ? AttemptPayment(
              data: widget.paymentData,
            )
          : PayAddress(
              paymentData: widget.paymentData,
              disabledFields: _getDisabledPayFormField(),
            );

      var route = MaterialPageRoute(builder: (_) => PrivateRoute(page));
      await Navigator.of(context).push(route).then(_onFinished);
    }
  }

  Future<dynamic> _ensureLoggedIn() async {
    var isLoggedIn = await Auth.isLoggedIn();
    if (!isLoggedIn) {
      var loggedIn = await _login();
      if (!loggedIn) {
        return RecPlatform.closeApp(context);
      }
    }
  }

  Future<dynamic> _onFinished(result) {
    var navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return null;
    }

    return navigator.pushReplacementNamed(Routes.home);
  }

  Future<bool> _login() {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => LoginPage(
          onLogin: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }

  List<String> _getDisabledPayFormField() {
    return [
      widget.paymentData.concept != null &&
              widget.paymentData.concept.isNotEmpty
          ? 'concept'
          : null,
      widget.paymentData.amount != null && widget.paymentData.amount >= 0
          ? 'amount'
          : null,
    ];
  }

  Future<VendorData> _getVendorDataFromAddress(String address) async {
    return transactionsService
        .getVendorInfoFromAddress(address)
        .catchError(_showErrorToast);
  }

  void _showErrorToast(error) => RecToast.showError(context, error.message);
}
