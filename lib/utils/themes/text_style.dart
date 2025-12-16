import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF333333),
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF333333),
  );

  static TextStyle body1 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF666666),
  );

  static TextStyle body2 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF666666),
  );

  static const TextStyle heading3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  static const TextStyle body = TextStyle(fontSize: 16);

  static const TextStyle bodyBold = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  static const TextStyle small = TextStyle(fontSize: 14, color: Colors.grey);
}
