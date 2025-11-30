import 'package:flutter/material.dart';

class AppTheme {
  // -------------------------------------------------------------------
  // APPLE GLASSY LIGHT THEME
  // -------------------------------------------------------------------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFFF5F5F7),
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF007AFF),     // blue highlight (iOS-style)
      secondary: Color.fromRGBO(255, 255, 255, 0.6),
      tertiary: Color(0xFF1C1C1E),
      surface: Color(0xFFD1D1D6),
      onPrimary: Colors.white,
      onSecondary: Color(0xFF1C1C1E),
      onSurface: Color(0xFF1C1C1E),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1C1C1E)),
      bodyMedium: TextStyle(color: Color(0xFF1C1C1E)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF007AFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.15),
      ),
    ),

    // -------- Bottom Navigation Bar (IMPORTANT) ----------
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF007AFF),
      unselectedItemColor: Color(0xFF8E8E93),
      selectedIconTheme: IconThemeData(color: Color(0xFF007AFF), size: 26),
      unselectedIconTheme: IconThemeData(color: Color(0xFF8E8E93), size: 24),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
  );

  // -------------------------------------------------------------------
  // APPLE GLASSY DARK THEME
  // -------------------------------------------------------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1C1C1E),
    scaffoldBackgroundColor: const Color(0xFF1C1C1E),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0A84FF),     // iOS Dark blue
      secondary: Color.fromRGBO(28, 28, 30, 0.6),
      tertiary: Color(0xFFF5F5F7),
      surface: Color(0xFF3A3A3C),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0A84FF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
    ),

    // -------- Bottom Navigation Bar (Dark) ----------
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1C1C1E),
      selectedItemColor: Color(0xFF0A84FF),
      unselectedItemColor: Color(0xFF8E8E93),
      selectedIconTheme: IconThemeData(color: Color(0xFF0A84FF), size: 26),
      unselectedIconTheme: IconThemeData(color: Color(0xFF8E8E93), size: 24),
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
  );
}
