import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTitelstyle(
    {double fontSize = 18,
    FontWeight fontWeight = FontWeight.bold,
    Color color = const Color(0xff0B8FAC)}) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: GoogleFonts.cairo().fontFamily);
}

TextStyle getBodystyle(
    {double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = const Color(0xff121212)}) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: GoogleFonts.cairo().fontFamily);
}

TextStyle getsmallstyle(
    {double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = const Color(0xffB4AAAA)}) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: GoogleFonts.cairo().fontFamily);
}
