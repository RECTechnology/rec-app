import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rec/Api/ApiError.dart';
import 'package:rec/Api/Services/wallet/TransactionsService.dart';
import 'package:rec/Permissions/IfPermissionGranted.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Entities/VendorData.ent.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/Deeplinking.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/AttemptPayment.page.dart';
import 'package:rec/Permissions/PermissionProviders.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';

class PayWithQR extends StatefulWidget {
  @override
  _PayWithQRState createState() => _PayWithQRState();
}

class _PayWithQRState extends State<PayWithQR> {
  final TransactionsService transactionsService = TransactionsService();

  Barcode result;
  QRViewController controller;
  PaymentData paymentData;

  @override
  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: EmptyAppBar(context, title: 'PAY_WITH_QR'),
      body: IfPermissionGranted(
        permission: PermissionProviders.qr,
        builder: (_) => _content(),
        onDecline: () {},
        canBeDeclined: false,
      ),
    );
  }

  Widget _content() {
    return Column(
      children: <Widget>[
        _qrView(),
        _bottomTexts(),
      ],
    );
  }

  Widget _qrView() {
    var scanArea = MediaQuery.of(context).size.width * 0.8;
    return Expanded(
      flex: 4,
      child: QRView(
        key: GlobalKey(debugLabel: 'QR'),
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Brand.green,
          borderLength: 30,
          cutOutSize: scanArea,
        ),
      ),
    );
  }

  Widget _bottomTexts() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statusText(),
            _hintText(),
          ],
        ),
      ),
    );
  }

  Widget _statusText() {
    var localizations = AppLocalizations.of(context);
    var hasFoundCode = result != null;
    var statusText = hasFoundCode
        ? localizations.translate('FOUND_QR')
        : localizations.translate('SCANNING');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        statusText,
        textAlign: TextAlign.center,
        style: TextStyles.outlineTileText.copyWith(
          fontWeight: FontWeight.w400,
          color: Brand.grayDark3,
        ),
      ),
    );
  }

  Widget _hintText() {
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Text(
        localizations.translate('QR_HINT'),
        textAlign: TextAlign.center,
        style: TextStyles.outlineTileText,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(_onQrRead);
  }

  void _onQrRead(Barcode data) async {
    var uri = data.code;
    var isPayLink = Deeplinking.matchesPaymentUri(env, uri);

    if (!isPayLink) return result = null;
    if (result != null) return;

    setState(() => result = data);

    paymentData = PaymentData.fromUriString(uri);
    paymentData.vendor = await _getVendorDataFromAddress(
      paymentData.address,
    );

    if (paymentData.vendor == null) {
      _showErrorToast(
        ApiError(message: 'NOT_FOUND'),
      );
    }

    return _openPinPage();
  }

  Future<VendorData> _getVendorDataFromAddress(String address) async {
    return transactionsService
        .getVendorInfoFromAddress(address)
        .catchError(_showErrorToast);
  }

  void _openPinPage() {
    var route = MaterialPageRoute(
      builder: (ctx) => AttemptPayment(
        data: paymentData,
      ),
    );

    Navigator.of(context).push(route).then((value) {
      if (value == true) {
        Navigator.of(context).pop(value);
      } else {
        setState(() => result = null);
      }
    });
  }

  void _showErrorToast(error) => RecToast.showError(context, error.message);

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
