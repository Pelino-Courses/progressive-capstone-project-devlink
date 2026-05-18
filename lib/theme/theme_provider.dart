import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeData get theme => _isDarkMode ? AppTheme.darkTheme : AppTheme.theme;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}