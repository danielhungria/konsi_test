import 'package:flutter/material.dart';
import 'colours.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      colorScheme: const ColorScheme(
        primary: Colours.primaryColour,
        secondary: Colours.secondaryColour,
        surface: Colours.softBackgroundColour,
        onPrimary: Colours.lightBackgroundColour,
        onSecondary: Colours.darkTextColour,
        onSurface: Colours.darkTextColour,
        error: Colors.red,
        onError: Colours.lightBackgroundColour,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colours.secondaryColour,
        selectedItemColor: Colours.primaryColour,
        unselectedItemColor: Colours.neutralTextColour,
      ),
    );
  }
}
