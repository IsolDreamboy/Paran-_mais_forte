import 'package:flutter/material.dart';

ThemeData appTheme() {
  const Color primary = Color(0xFF3A6EA5);      // azul clean  
  const Color accent = Color(0xFF7BA4D9);       // azul pastel  
  const Color softGray = Color(0xFFF4F6F8);     // fundo moderno

  return ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: softGray,

    // APPBAR ultra minimalista
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.black87,
      shadowColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),

    // TIPOGRAFIA minimalista
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.4,
      ),
    ),

    // CARDS NOTION STYLE
   cardTheme: CardThemeData(
  color: Colors.white,
  elevation: 1,
  margin: const EdgeInsets.symmetric(vertical: 12),
  surfaceTintColor: Colors.transparent,
  shadowColor: Colors.black12,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
),


    // BOTÕES CLEAN
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),

    // outline buttons estilo iOS settings
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: primary.withOpacity(0.4), width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        foregroundColor: primary,
      ),
    ),
  );
}
