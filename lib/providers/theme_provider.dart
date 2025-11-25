import 'package:flutter/material.dart';
import '../constants.dart'; // accentColor buradan gelecek

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// Tema Oluşturucu Fonksiyon
ThemeData buildCustomTheme({required Brightness brightness}) {
  final isLight = brightness == Brightness.light;
  final primaryBackgroundColor = isLight ? Colors.white : const Color(0xFF282C34);
  final primaryTextColor = isLight ? Colors.black87 : Colors.white;
  final semiOpaqueColor = primaryTextColor.withAlpha((255 * 0.8).round());

  return ThemeData(
    primaryColor: accentColor,
    hintColor: accentColor,
    brightness: brightness,
    scaffoldBackgroundColor: primaryBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    // ... main.dart'taki TextTheme, InputDecorationTheme vb. ayarlarını buraya kopyala ...
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue).copyWith(secondary: accentColor, brightness: brightness),
  );
}