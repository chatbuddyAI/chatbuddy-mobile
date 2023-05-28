import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  void _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
  }

  void _saveTheme() {
    _prefs.setBool('isDarkMode', _isDarkMode);
  }
}
