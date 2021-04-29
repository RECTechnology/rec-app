import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rec/Api/ApiError.dart';
import 'package:rec/Api/Services/wallet/TransactionsService.dart';
import 'package:rec/Components/FromToRow.dart';
import 'package:rec/Components/IfPermissionGranted.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Entities/VendorData.ent.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/Deeplinking.dart';
import 'package:rec/Helpers/Loading.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayPin.page.dart';
import 'package:rec/Permissions/PermissionProviders.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class PayWithQR extends StatefulWidget {
  @override
  _PayWithQRState createState() => _PayWithQRState();
}

class _PayWithQRState extends State<PayWithQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TransactionsService transactionsService = TransactionsService();

  Barcode result;
  QRViewController controller;
  PaymentData paymentData;

  @override
  Widget build(BuildContext context) {
    return IfPermissionGranted(
      permission: PermissionProviders.qr,
      child: _content(),
    );
  }

  Widget _content() {
    return Scaffold(
      appBar: EmptyAppBar(context, title: 'PAY_WITH_QR'),
      body: Column(
        children: <Widget>[
          _qrView(),
          _bottomTexts(),
        ],
      ),
    );
  }

  Widget _qrView() {
    var scanArea = MediaQuery.of(context).size.width * 0.8;
    return Expanded(
      flex: 4,
      child: QRView(
        key: qrKey,
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
        ? localizations.translate('FOUND_PAYMENT')
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

  void _showErrorToast(error) => RecToast.showError(context, error.message);

  void _openPinPage() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (ctx) => PayPin(
              data: paymentData,
              onPin: _gotPin,
            ),
          ),
        )
        .then((value) => setState(() => result = null));
  }

  void _gotPin(String pin) async {
    paymentData.pin = pin;

    _showCustomLoading();

    await transactionsService
        .makePayment(paymentData)
        .then(_onPaymentOk)
        .catchError(_onPaymentError);
  }

  void _showCustomLoading() {
    var userState = UserState.of(context, listen: false);
    var localizations = AppLocalizations.of(context);

    Loading.showCustom(
      status: localizations.translate('MAKING_PAYMENT'),
      content: FromToRow(
        from: CircleAvatarRec.fromAccount(userState.account),
        to: CircleAvatarRec(imageUrl: paymentData.vendor.image),
      ),
    );
  }

  void _onPaymentOk(resp) {
    var localizations = AppLocalizations.of(context);
    var transactionProvider = TransactionProvider.of(context, listen: false);

    transactionProvider.refresh();

    Loading.dismiss();
    Navigator.popUntil(context, ModalRoute.withName(Routes.home));
    RecToast.showSuccess(context, localizations.translate('PAYMENT_OK'));
  }

  void _onPaymentError(error) {
    Loading.dismiss();
    _showErrorToast(error);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
