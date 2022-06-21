import 'package:flutter/material.dart';
import 'package:rec/config/brand.dart';
import 'package:styled_text/styled_text.dart';

final StyledTextTag boldTag = StyledTextTag(
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Brand.defectText,
  ),
);

final StyledTextTag semiboldTag = StyledTextTag(
  style: const TextStyle(
    fontWeight: FontWeight.w500,
    color: Brand.defectText,
  ),
);

final StyledTextTag primaryTag = StyledTextTag(
  style: const TextStyle(color: Brand.primaryColor),
);

final StyledTextTag secondaryTag = StyledTextTag(
  style: const TextStyle(color: Brand.accentColor),
);

final StyledTextTag greenTag = StyledTextTag(
  style: const TextStyle(color: Brand.badgeGreen),
);

final StyledTextTag redTag = StyledTextTag(
  style: const TextStyle(color: Brand.amountNegative),
);

final Map<String, StyledTextTagBase> defaultTags = {
  'bold': boldTag,
  'semibold': semiboldTag,
  'primary': primaryTag,
  'secondary': secondaryTag,
  'green': greenTag,
  'red': redTag,
};
