import 'package:flutter/material.dart';
import 'package:rec/helpers/rec_preferences.dart';

enum PreferenceType {
  string,
  selector,
  checkbox,
  toggle,
}

class Preference<T> {
  final T? defaultValue;
  final List<T> acceptedValues;
  final String storageKey;
  final String prettyName;
  final PreferenceType type;
  final Function(BuildContext context, T value)? _onChanged;

  Preference({
    required this.storageKey,
    this.acceptedValues = const [],
    Function(BuildContext context, T value)? onChanged,
    this.defaultValue,
    String? prettyName,
    PreferenceType? type = PreferenceType.string,
    dynamic value,
  })  : prettyName = prettyName ?? storageKey,
        type = type ?? PreferenceType.string,
        _onChanged = onChanged;

  T? get value {
    var valueInStorage = RecPreferences.get(storageKey) as T?;
    return valueInStorage ?? defaultValue;
  }

  Future<bool>? set(T value) {
    return RecPreferences.set(storageKey, value);
  }

  void onChanged(BuildContext context, T value) {
    if (_onChanged != null) {
      _onChanged!(context, value);
    }
  }

  Preference copyWith({dynamic value}) {
    return Preference(
      storageKey: storageKey,
      acceptedValues: acceptedValues,
      onChanged: onChanged as dynamic Function(BuildContext, dynamic)?,
      defaultValue: defaultValue,
      prettyName: prettyName,
      type: type,
    );
  }
}
