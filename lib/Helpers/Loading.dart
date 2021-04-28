import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';

class Loading {
  static Future<void> dismiss() {
    return EasyLoading.dismiss();
  }

  static Future<void> show({
    String status,
    Widget indicator,
    EasyLoadingMaskType maskType,
    bool dismissOnTap,
  }) {
    return EasyLoading.show();
  }

  static Future<void> showCustom({String status, Widget content}) {
    return show(
      status: status,
      indicator: Column(
        children: [
          content,
          Padding(
            padding: const EdgeInsets.all(16),
            child: LoadingIndicator(),
          )
        ],
      ),
    );
  }
}
