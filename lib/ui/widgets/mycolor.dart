import 'package:flutter/material.dart';

class MyColors{
  static const int _greyPrimaryValue = 0xFF5F6368;
  static const MaterialColor grey = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
       50: Color(0x285F6368),
      100: Color(0x565F6368),
      200: Color(0x835F6368),
      300: Color(0xB25F6368),
      400: Color(0xDC5F6368),
      500: Color(_greyPrimaryValue),
      // 600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
// 0xFF0990D0
  static const int _lightBluePrimaryValue = 0xFF0990D0;
  static const MaterialColor lightBlue = MaterialColor(
    _lightBluePrimaryValue,
    <int, Color>{
       50: Color(0xFFA2D7F6),
      100: Color(0xFF8DD0F6),
      200: Color(0xFF75C9FA),
      300: Color(0xFF5CC2FD),
      400: Color(0xFF4BBBFB),
      500: Color(0xFF38B6FF),
      600: Color(0xFF25ABF8),
      700: Color(0xFF18A8FB),
      800: Color(0xFF0CA4FB),
      900: Color(0xFF049EF8),
    },
  );

  static const Color blue700 = Color(0xFF1976D2);
}