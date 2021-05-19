import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppBrowser extends StatefulWidget {
  final String url;
  final void Function(String) onPageStarted;
  final void Function(String) onPageFinished;
  final void Function(int) onProgress;
  final void Function(WebViewController) onWebViewCreated;

  const InAppBrowser({
    Key key,
    @required this.url,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebViewCreated,
  }) : super(key: key);

  @override
  _InAppBrowser createState() => _InAppBrowser();
}

class _InAppBrowser extends State<InAppBrowser> {
  WebViewController controller;
  int position = 1;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void doneLoading(String _) {
    setState(() {
      position = 0;
    });
    if (widget.onPageFinished != null) widget.onPageFinished(_);
  }

  void startLoading(String _) {
    setState(() {
      position = 1;
    });
    if (widget.onPageStarted != null) widget.onPageStarted(_);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: position,
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.disabled,
              onPageFinished: doneLoading,
              onPageStarted: startLoading,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
            ),
            Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
