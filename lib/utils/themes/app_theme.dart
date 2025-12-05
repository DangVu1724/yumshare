import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = lightTheme;
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
);
