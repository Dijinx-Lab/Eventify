import 'package:flutter/material.dart';

class ColorStyle {
  static Map<int, Color> primarySwatchColor = {
    50: const Color.fromRGBO(187, 38, 73, .1),
    100: const Color.fromRGBO(187, 38, 73, .2),
    200: const Color(0x4BBB2649),
    300: const Color.fromRGBO(187, 38, 73, .4),
    400: const Color.fromRGBO(187, 38, 73, .5),
    500: const Color.fromRGBO(187, 38, 73, .6),
    600: const Color.fromRGBO(187, 38, 73, .7),
    700: const Color.fromRGBO(187, 38, 73, .8),
    800: const Color.fromRGBO(187, 38, 73, .9),
    900: const Color.fromRGBO(187, 38, 73, 1),
  };

  static MaterialColor primaryMaterialColor =
      MaterialColor(0xFFBB2649, primarySwatchColor);

  static const primaryColor = Color(0xFFBB2649);
  static const primaryColorLight = Color(0xFFF35D74);
  static const primaryColorExtraLight = Color(0xFFFFC3D4);
  static const primaryTextColor = Color(0xFF4B4F5D);
  static const secondaryTextColor = Color(0xFF6A738B);
  static const accentColor = Color(0xFFFFD6A5);

  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF000000);
  static const cardColor = Color(0xFFEFEFEF);
}
