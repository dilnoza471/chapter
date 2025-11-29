import 'package:flutter/material.dart';

class AppTheme {
  // Apple Glassy Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFF5F5F7),
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFF5F5F7),
      secondary: Color.fromRGBO(255, 255, 255, 0.6),
      tertiary: Color(0xFF1C1C1E),
      surface: Color(0xFFD1D1D6),
      onPrimary: Color(0xFF1C1C1E),
      onSecondary: Color(0xFF1C1C1E),
      onSurface: Color(0xFF1C1C1E),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1C1C1E)),
      bodyMedium: TextStyle(color: Color(0xFF1C1C1E)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
    ),
  );

  // Apple Glassy Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1C1C1E),
    scaffoldBackgroundColor: const Color(0xFF1C1C1E),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1C1C1E),
      secondary: Color.fromRGBO(28, 28, 30, 0.6),
      tertiary: Color(0xFFF5F5F7),
      surface: Color(0xFF3A3A3C),
      onPrimary: Color(0xFFF5F5F7),
      onSecondary: Color(0xFFF5F5F7),
      onSurface: Color(0xFFF5F5F7),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A84FF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
    ),
  );
}
