import 'package:flutter/material.dart';
import 'package:rec/providers/All.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RecAuth extends Auth {
  static get storage => Auth.storage;

  static Future<void> logout(BuildContext context) async {
    UserState.of(context, listen: false).clear();
    TransactionProvider.of(context, listen: false).clear();

    Auth.logout(context);
  }
}
