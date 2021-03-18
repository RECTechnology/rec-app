import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ApiProvider with ChangeNotifier {
  ApiProvider();

  static of(context, {listen = true}) {
    return Provider.of<ApiProvider>(context, listen: listen);
  }
}
