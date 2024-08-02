import 'package:flutter/material.dart';
import 'package:habitat/theme/dark_mode.dart';
import 'package:habitat/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // initial light mode

  ThemeData _themeData = darkMode;

  //
  ThemeData get themeData => _themeData;

  set themeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  bool get isDarkMode => _themeData == darkMode;

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
