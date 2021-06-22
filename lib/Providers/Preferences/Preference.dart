import 'package:flutter/material.dart';
import 'package:rec/Api/RecPreferences.dart';

enum PreferenceType {
  string,
  selector,
  checkbox,
  toggle,
}

class Preference<T> {
  T _value;
  final T defaultValue;
  final List<T> acceptedValues;
  final String storageKey;
  final String prettyName;
  final PreferenceType type;
  final Function(BuildContext context, T value) _onChanged;

  Preference({
    @required this.storageKey,
    this.acceptedValues = const [],
    Function(BuildContext context, T value) onChanged,
    dynamic defaultValue,
    String prettyName,
    PreferenceType type = PreferenceType.string,
  })  : defaultValue = defaultValue,
        prettyName = prettyName ?? storageKey,
        type = type,
        _onChanged = onChanged,
        _value = RecPreferences.get(storageKey) ?? defaultValue;

  T get value => _value;

  void set(T value) {
    _value = value;
    RecPreferences.set(storageKey, value);
  }

  void onChanged(BuildContext context, T value) {
    if (_onChanged != null) {
      _onChanged(context, value);
    }
  }
}