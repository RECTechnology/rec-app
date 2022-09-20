import 'dart:math';

import 'package:flutter/material.dart';

class ColorHelper {
  static Color getRandomPrimaryColorForSeed(int seed) {
    return Colors.primaries[Random(seed).nextInt(Colors.primaries.length)];
  }

  static Color getRandomColor(int seed) {
    final rand = Random(seed);
    final r = rand.nextInt(150) + 50;
    final g = rand.nextInt(150) + 50;
    final b = rand.nextInt(150) + 50;

    return Color.fromRGBO(r, g, b, 1);
  }

  static Color getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    if (luminance > .5) return Colors.black;

    return Colors.white;
  }
}
