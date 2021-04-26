import 'package:flutter/material.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';

class LemonWayPaymentWebView extends StatefulWidget {
  final String url;

  const LemonWayPaymentWebView({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  _LemonWayPaymentWebView createState() => _LemonWayPaymentWebView();
}

class _LemonWayPaymentWebView extends State<LemonWayPaymentWebView> {
  @override
  Widget build(BuildContext context) {
    return InAppBrowser(
      url: widget.url,
    );
  }
}
