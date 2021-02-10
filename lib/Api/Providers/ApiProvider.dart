import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../ApiClient.dart';

class ApiProvider with ChangeNotifier {
  ApiClient client;

  ApiProvider({@required this.client});

  static of(context, {listen = true}) {
    return Provider.of<ApiProvider>(context, listen: listen);
  }
}
