import 'package:flutter/material.dart';

class RecFilterData<T> {
  final String id;
  final IconData icon;
  final String label;
  final bool isEnabled;
  final T defaultValue;
  final Color color;

  RecFilterData({
    this.id,
    this.icon,
    this.label,
    this.isEnabled,
    this.defaultValue,
    this.color
  });
}
