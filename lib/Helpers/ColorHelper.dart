import 'dart:math';

import 'package:flutter/material.dart';

class ColorHelper {
  static Color getRandomPrimaryColorForSeed(int seed) {
    var color = Colors.primaries[Random(seed).nextInt(Colors.primaries.length)];
    return color;
  }

  static Color getRandomColorForSeed(int seed) {
    var rand = Random(seed);
    var r = rand.nextInt(150) + 50;
    var g = rand.nextInt(150) + 50;
    var b = rand.nextInt(150) + 50;

    var color = Color.fromRGBO(r, g, b, 1);
    return color;
  }

  static Color getContrastColor(Color randomColor) {
    var luminance = randomColor.computeLuminance();
    if (luminance > .5) return Colors.black;

    return Colors.white;
  }
}
