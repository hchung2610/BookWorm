import 'package:flutter/material.dart';
import 'package:practice_proj/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool isDark = false;

  ThemeData get themeData => _themeData;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
      isDark = true;
    } else {
      _themeData = lightMode;
      isDark = false;
    }
    notifyListeners();
  }
}
