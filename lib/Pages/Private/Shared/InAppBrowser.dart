import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rec/brand.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppBrowser extends StatefulWidget {
  final String url;
  final void Function(String) onPageStarted;
  final void Function(String) onPageFinished;
  final void Function(int) onProgress;
  final void Function(WebViewController) onWebViewCreated;

  final bool debug;

  const InAppBrowser({
    Key key,
    @required this.url,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebViewCreated,
    this.debug = false,
  }) : super(key: key);

  @override
  _InAppBrowser createState() => _InAppBrowser();
}

class _InAppBrowser extends State<InAppBrowser> {
  WebViewController controller;
  int position = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void startLoading(String path) {
    if (widget.debug) print('Started loading: $path');
    if (widget.onPageStarted != null) widget.onPageStarted(path);

    setState(() {
      position = 1;
      isLoading = true;
    });
  }

  void doneLoading(String path) {
    if (widget.debug) print('End loading: $path');
    if (widget.onPageFinished != null) widget.onPageFinished(path);

    setState(() {
      position = 0;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: doneLoading,
              onPageStarted: startLoading,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
            ),
            AnimatedOpacity(
              opacity: isLoading ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: LinearProgressIndicator(
                color: Brand.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
