import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.light;
  String _currentLanguage = 'en';

  ThemeMode get currentTheme => _currentTheme;
  String get currentLanguage => _currentLanguage;

  void setTheme(ThemeMode theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void setLanguage(String language) {
    _currentLanguage = language;
    notifyListeners();
  }
}
