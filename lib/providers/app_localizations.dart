import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/Strings.dart';

/// Handles localizations/translations within the app
/// TODO: Refactor and/or replace with KLocalizations
class AppLocalizations {
  static const delegate = _AppLocalizationsDelegate();
  static Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];
  static const supportedLocales = [
    Locale('ca', 'CA'),
    Locale('es', 'ES'),
    Locale('en', 'UK'),
  ];
  static const supportedLocaleNames = ['ca', 'es', 'en'];

  static Locale getLocaleByLanguageCode(String languageCode) {
    return supportedLocales.firstWhere(
      (lang) => lang.languageCode == languageCode,
      orElse: () => supportedLocales.first,
    );
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Locale? localeResolutionCallback(locale, supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      if (areLocalesEqual(supportedLocale, locale)) {
        return supportedLocale;
      }
    }

    return supportedLocales.first;
  }

  static bool areLocalesEqual(Locale first, Locale second) {
    return first.languageCode == second.languageCode || first.countryCode == second.countryCode;
  }

  /// Defines the current locale that is being used in the App
  Locale locale;
  Map<String, dynamic> _localizedStrings = <String, dynamic>{};

  Client httpClient;

  AppLocalizations(this.locale, {Client? client}) : httpClient = client ?? Client();

  /// Set the locale
  /// If locale is not supported it will fallback to [supportedLocales.first]
  void setLocale(Locale locale) {
    localeResolutionCallback(locale, supportedLocales);
  }

  /// Main method, given a [key] and a set of [params],
  /// return the translated for the current [locale]
  String translate(String key, {Map<String, dynamic>? params}) {
    var translation = _localizedStrings[key] ?? key;
    if (params != null) {
      return Strings.interpolate(translation, params: params);
    }

    return translation;
  }

  /// Loads translations for current locale
  Future<bool> load() async {
    print('Loading language: ${locale.languageCode}');

    // If we're in testing mode, we cannot load from CDN, load locally
    if (env.FORCE_LOAD_FROM_LOCAL ||
        (!env.FORCE_LOAD_FROM_CDN &&
            (Platform.environment.containsKey('FLUTTER_TEST') || kDebugMode))) {
      print('DEVELOPMENT: Loaded from local assets');
      final jsonMap = await (_loadMapForLocale());
      _localizedStrings = jsonMap!.map(_mapEntry);
      return true;
    }

    // Try loading from cdn, otherwise fallback to local asset file
    try {
      final cdnFile = await _loadStringForCurrentLocaleFromCdn();
      _localizedStrings = cdnFile;
      print('Loaded from cdn');
    } catch (e) {
      print('Error loading from CDN: $e');
      final jsonMap = await (_loadMapForLocale());
      _localizedStrings = jsonMap!.map(_mapEntry);
      print('Loaded from local assets');
    }

    return true;
  }

  /// Return the pretty name for a specific languageCode
  String getLocaleNameByLocaleId(String id) {
    if (id == 'es') return 'Español';
    if (id == 'en') return 'Ingles';
    if (id == 'ca') return 'Catalan';

    return 'Español';
  }

  MapEntry<String, String> _mapEntry(String key, value) => MapEntry(key, value.toString());

  Future<Map<String, dynamic>> _loadStringForCurrentLocaleFromCdn() async {
    final uri = Uri(
      scheme: 'https',
      host: env.CDN_URL,
      path: 'file/${env.TRANSLATIONS_PROJECT_ID}/${locale.languageCode}.json',
    );
    final result = await httpClient.get(uri);
    if (result.statusCode >= 300) {
      throw Exception(result.body);
    }

    final data = utf8.decode(result.bodyBytes);
    final dataJson = json.decode(data);

    return dataJson;
  }

  Future<String> _loadStringForCurrentLocale() {
    return rootBundle.loadString('assets/current/i18n/${locale.languageCode}.json');
  }

  Future<Map<String, dynamic>?> _loadMapForLocale() async {
    var jsonString = await _loadStringForCurrentLocale();
    return json.decode(jsonString);
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) async {
    var localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocaleNames.contains(locale.languageCode);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
