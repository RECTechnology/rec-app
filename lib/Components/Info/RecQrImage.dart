import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RecQrImage extends StatefulWidget {
  final String qrContent;

  const RecQrImage(this.qrContent, {Key key}) : super(key: key);

  @override
  _RecQrImage createState() => _RecQrImage();
}

class _RecQrImage extends State<RecQrImage> {
  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: widget.qrContent,
      version: QrVersions.auto,
      size: MediaQuery.of(context).size.width * 0.7,
    );
  }
}
