import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'Environments/env-local.dart';
import 'Providers/AppState.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the token from storage
  var token = await Auth.getToken();

  // Create AppState change notifier provider
  var appStateProvider = ChangeNotifierProvider(
    create: (context) => AppState(),
    child: RecApp(token),
  );

  if (env.SENTRY_ACTIVE) {
    await SentryFlutter.init(
      (options) => options.dsn = env.SENTRY_DSN,
      appRunner: () => runApp(appStateProvider),
    );
  } else {
    runApp(appStateProvider);
  }
}
