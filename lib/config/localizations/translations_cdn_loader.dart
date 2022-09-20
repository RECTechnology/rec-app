import 'dart:ui';
import 'package:klocalizations_flutter/klocalizations_flutter.dart';

// TODO: try to load from CDN, if there is an error fallback to default local file
class TranslationCdnLoader extends KLocalizationsLoader {
  final String projectId;

  TranslationCdnLoader(this.projectId);

  @override
  Future<Map<String, dynamic>> loadMapForLocale(Locale locale) async {
    return {};
  }
}
