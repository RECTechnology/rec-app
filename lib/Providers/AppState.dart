import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/*
 * This class is a ChangeNotifier and is provided across the app. 
 * Any changes made to this class will propagate from the ChangeNotifierProvider.
 * This class should only contain information required across the whole app, like user information, account, etc... 
 * Not for sharing info across pages/views/etc...
 */
class AppState with ChangeNotifier {
  static AppState of(context) {
    return Provider.of<AppState>(context);
  }
}
