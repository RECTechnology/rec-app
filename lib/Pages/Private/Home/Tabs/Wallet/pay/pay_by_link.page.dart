import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/Components/PrivateRoute.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/attempt_payment.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/pay_to_address.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/no_permissions_to_pay.dart';
import 'package:rec/Pages/Public/Login/Login.page.dart';
import 'package:rec/config/roles_definitions.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecPlatformHelper.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/mixins/loadable_mixin.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class PayLink extends StatefulWidget {
  /// Handles onGenerateRoute,
  /// will be called if a generated route matches [Routes.payLink]
  static MaterialPageRoute handleRoute(RouteSettings settings, Env env) {
    return MaterialPageRoute(
      builder: (ctx) => PayLink(
        paymentData: PaymentData.fromUriString(
          '${env.DEEPLINK_URL}${settings.name}',
        ),
      ),
    );
  }

  final PaymentData paymentData;

  PayLink({
    Key? key,
    required this.paymentData,
  }) : super(key: key);

  @override
  _PayLinkState createState() => _PayLinkState();
}

class _PayLinkState extends State<PayLink> with Loadable {
  final TransactionsService transactionsService = TransactionsService(env: env);
  String? error;
  bool hasPermissions = true;

  @override
  void initState() {
    super.initState();

    if (widget.paymentData.address == null) {
      error = 'INVALID_LINK';
    }

    if (error == null) _setup();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasPermissions) {
      return NoPermissionsToPay();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: error != null
            ? Center(
                child: LocalizedText(
                  error!,
                  textAlign: TextAlign.center,
                ),
              )
            : Center(
                child: LocalizedText('LOADING'),
              ),
      ),
    );
  }

  void _setup() async {
    await _ensureLoggedIn();
    var userState = UserState.deaf(context);
    await userState.getUser();

    var hasPermissionToPay = userState.user!.hasRoles(RoleDefinitions.payFromLink);

    if (!hasPermissionToPay) {
      setState(() {
        hasPermissions = false;
      });
      return;
    }

    var vendorData =
        await _getVendorDataFromAddress(widget.paymentData.address).catchError(_showErrorToast);

    // ignore: unnecessary_null_comparison
    if (vendorData != null) {
      widget.paymentData.vendor = vendorData;
      var isPaymentDataComplete = widget.paymentData.isComplete();
      var page = isPaymentDataComplete
          ? AttemptPayment(
              data: widget.paymentData,
            )
          : PayAddressPage(
              paymentData: widget.paymentData,
              disabledFields: _getDisabledPayFormField(),
            );

      // TODO: check if private route is required here, and if not replace it
      // ignore: deprecated_member_use_from_same_package
      var route = MaterialPageRoute(builder: (_) => PrivateRoute(page));
      await Navigator.of(context).push(route).then(_onFinished);
    }
  }

  Future<dynamic> _ensureLoggedIn() async {
    var isLoggedIn = await Auth.isLoggedIn();

    if (!isLoggedIn) {
      var loggedIn = await (_login());

      if (loggedIn == false) {
        return RecPlatform.closeApp(context);
      }
    }
  }

  Future<dynamic>? _onFinished(result) {
    var navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return null;
    }

    return navigator.pushReplacementNamed(Routes.home);
  }

  Future<bool?> _login() {
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

  List<String?> _getDisabledPayFormField() {
    return [
      widget.paymentData.concept.isNotEmpty ? 'concept' : null,
      widget.paymentData.amount != null && widget.paymentData.amount! >= 0 ? 'amount' : null,
    ];
  }

  Future<VendorData> _getVendorDataFromAddress(String? address) async {
    return transactionsService.getVendorInfoFromAddress(address).catchError(_showErrorToast);
  }

  _showErrorToast(error) => RecToast.showError(context, error.message);

  @override
  void setIsLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }
}
