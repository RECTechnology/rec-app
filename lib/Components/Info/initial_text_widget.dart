import 'package:flutter/material.dart';
import 'package:rec/helpers/color_helper.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// It displays the initial letter of a name, with a pseudorandom text color
///
/// It colors the text based on the seed
class InitialTextWidget extends StatelessWidget {
  /// Seed to generate the letter color
  final int seed;

  /// Optional name to get the initial from
  final String? name;

  /// Defaul name to get the initial from in case [name] is null
  final String defaultName;

  /// optional icon to show instead of the initial
  final Widget? icon;

  const InitialTextWidget({
    Key? key,
    required this.seed,
    required this.defaultName,
    this.name,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final randomColor = ColorHelper.getRandomColor(seed);

    Widget child = Text(
      'P',
      style: TextStyle(color: ColorHelper.getContrastColor(randomColor)),
    );

    if (icon != null) {
      child = icon!;
    }

    if (name != null) {
      final hasName = Checks.isNotEmpty(name);
      final effectiveName = !hasName ? defaultName : name!;

      child = Text(
        effectiveName[0].toUpperCase(),
        style: TextStyle(color: ColorHelper.getContrastColor(randomColor)),
      );
    }

    return child;
  }
}
