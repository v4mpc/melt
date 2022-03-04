import 'package:flutter/material.dart';

class CustomTheme {
  static final Color _primaryColor = Color(0xFFFFEE58);

  static ThemeData get darkTheme => _buildDarkTheme();

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    // final ThemeData base = ThemeData.light();
    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        color: _primaryColor,
        foregroundColor: Colors.black

      ),
      primaryColor: _primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(3),
        filled: true,
        fillColor: Colors.grey,
        focusColor: Colors.grey,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryColor,width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryColor,width: 3),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
