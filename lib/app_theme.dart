import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF800000); //Bordeaux
  static const Color accentColor = Color(0xFFB71C1C);
  static const Color secondaryColor = Color(
    0xFFF5F5F5,
  ); // Trắng / Xám nhạt backdrop

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87, //Màu text/icon trên AppBar
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      fontFamily: 'Roboto', //font mặc định tạm thời
      // cardTheme: CardTheme(
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //   margin: const EdgeInsets.only(bottom: 16),
      // ),
      useMaterial3: true,
    );
  }
}
