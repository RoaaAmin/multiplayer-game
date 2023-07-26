// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainColor {
  static Color primaryColor = Color(0xff3D1F81);
  static Color secondaryColor = Color(0xffECC754);
  static Color accentColor = Color(0xffEA614E);
}

var customFontWhite = GoogleFonts.coiny(
  textStyle: TextStyle(
    color: Colors.white,
    letterSpacing: 3,
    fontSize: 28,
  ),
);

var customFontBlack = GoogleFonts.coiny(
  textStyle: TextStyle(
    color: Colors.black,
    letterSpacing: 3,
    fontSize: 28,
  ),
);
