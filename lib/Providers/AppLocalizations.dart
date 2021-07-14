import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rec/Helpers/Strings.dart';

/// Handles localizations/translations within the app
class AppLocalizations {
  static const delegate = _AppLocalizationsDelegate();
  static Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];
  static const supportedLocales = [
    Locale('es', 'ES'),
    Locale('en', 'UK'),
    Locale('ca', 'CA'),
  ];
  static const supportedLocaleNames = ['es', 'en', 'ca'];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Locale localeResolutionCallback(locale, supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      if (areLocalesEqual(supportedLocale, locale)) {
        return supportedLocale;
      }
    }

    return supportedLocales.first;
  }

  static bool areLocalesEqual(Locale first, Locale second) {
    return first.languageCode == second?.languageCode ||
        first.countryCode == second?.countryCode;
  }

  /// Defines the current locale that is being used in the App
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  /// Set the locale
  /// If locale is not supported it will fallback to [supportedLocales.first]
  void setLocale(Locale locale) {
    localeResolutionCallback(locale, supportedLocales);
  }

  /// Main method, given a [key] and a set of [params],
  /// return the translated for the current [locale]
  String translate(String key, {Map<String, dynamic> params}) {
    var translation = _localizedStrings[key] ?? key;
    if (params != null) {
      return Strings.interpolate(translation, params: params);
    }

    return translation;
  }

  /// Loads translations for current locale
  Future<bool> load() async {
    var jsonMap = await _loadMapForLocale();
    _localizedStrings = jsonMap.map(_mapEntry);

    return true;
  }

  /// Return the pretty name for a specific languageCode
  String getLocaleNameByLocaleId(String id) {
    if (id == 'es') return 'Español';
    if (id == 'en') return 'Ingles';
    if (id == 'ca') return 'Catalan';

    return 'Español';
  }

  MapEntry<String, String> _mapEntry(String key, value) =>
      MapEntry(key, value.toString());

  Future<String> _loadStringForCurrentLocale() {
    return rootBundle.loadString('i18n/${locale.languageCode}.json');
  }

  Future<Map<String, dynamic>> _loadMapForLocale() async {
    var jsonString = await _loadStringForCurrentLocale();
    return json.decode(jsonString);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
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
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
