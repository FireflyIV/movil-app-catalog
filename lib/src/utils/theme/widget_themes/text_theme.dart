import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/colors.dart';

/* -- Light & Dark Text Themes -- */
class TTextTheme {
  TTextTheme._(); //To avoid creating instances

  /* -- Light Text Theme -- */
  static TextTheme lightTextTheme = TextTheme(
    headline1: GoogleFonts.poppins(fontSize: 28.0, fontWeight: FontWeight.bold, color: tDarkColor),
    headline2: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w700, color: tDarkColor),
    headline3: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.normal, color: tDarkColor),
    headline4: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600, color: tDarkColor),
    headline5: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.normal, color: tDarkColor),
    headline6: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: tDarkColor),
    bodyText1: GoogleFonts.poppins(fontSize: 14.0, color: tDarkColor),
    bodyText2: GoogleFonts.poppins(fontSize: 14.0, color: tDarkColor.withOpacity(0.8)),
  );

  /* -- Dark Text Theme -- */
  static TextTheme darkTextTheme = TextTheme(
    headline1: GoogleFonts.poppins(fontSize: 28.0, fontWeight: FontWeight.bold, color: tWhiteColor),
    headline2: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.w700, color: tWhiteColor),
    headline3: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.normal, color: tWhiteColor),
    headline4: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600, color: tWhiteColor),
    headline5: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.normal, color: tWhiteColor),
    headline6: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: tWhiteColor),
    bodyText1: GoogleFonts.poppins(fontSize: 14.0, color: tWhiteColor),
    bodyText2: GoogleFonts.poppins(fontSize: 14.0, color: tWhiteColor.withOpacity(0.8)),
  );
}
