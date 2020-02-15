import 'package:flutter/material.dart' show MaterialColor;
import 'package:flutter/widgets.dart';

class MkColors {
  static const _basePrimary = 0xFF121212;
  static const _baseSecondary = 0xFF03dac4;
  static const MaterialColor white = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFfafafa),
      200: Color(0xFFf5f5f5),
      300: Color(0xFFf0f0f0),
      400: Color(0xFFdedede),
      500: Color(0xFFc2c2c2),
      600: Color(0xFF979797),
      700: Color(0xFF818181),
      800: Color(0xFF606060),
      900: Color(0xFF3c3c3c),
    },
  );
  static const MaterialColor primaryAccent = MaterialColor(
    _basePrimary,
    <int, Color>{
      50: Color(0xFFf7f7f7),
      100: Color(0xFFeeeeee),
      200: Color(0xFFe2e2e2),
      300: Color(0xFFd0d0d0),
      400: Color(0xFFababab),
      500: Color(0xFF8a8a8a),
      600: Color(0xFF636363),
      700: Color(0xFF505050),
      800: Color(0xFF323232),
      900: Color(_basePrimary),
    },
  );
  static const MaterialColor secondaryAccent = MaterialColor(
    _baseSecondary,
    <int, Color>{
      50: Color(0xFFd4f6f2),
      100: Color(0xFF92e9dc),
      200: Color(_baseSecondary),
      300: Color(0xFF00c7ab),
      400: Color(0xFF00b798),
      500: Color(0xFF00a885),
      600: Color(0xFF009a77),
      700: Color(0xFF008966),
      800: Color(0xFF007957),
      900: Color(0xFF005b39),
    },
  );
  static const Color primary = Color(_basePrimary);
  static const Color secondary = Color(_baseSecondary);
  static const Color light_grey = Color(0xFF9B9B9B);
  static const Color success = Color(0xFF7ED321);
  static const Color danger = Color(0xFFEB5757);
  static const Color info = Color(0xFF2D9CDB);
  static const Color warning = Color(0xFFF1B61E);
}
