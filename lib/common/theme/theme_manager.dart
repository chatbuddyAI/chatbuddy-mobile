import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  bool _isDarkMode = false;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeManager() {
    _loadTheme();
  }
  get themeMode => _themeMode;

  togggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _isDarkMode = isDarkMode;
    saveThemeMode();
    notifyListeners();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print('I AM LOADING THEME MODE');
    }
    _themeMode =
        prefs.getBool('isDarkMode') ?? false ? ThemeMode.dark : ThemeMode.light;

    if (kDebugMode) {
      print(prefs.getBool('isDarkMode'));
    }
  }

  void saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print('I AM LOADING THEME MODE');
    }

    prefs.setBool('isDarkMode', _isDarkMode);
  }
}
