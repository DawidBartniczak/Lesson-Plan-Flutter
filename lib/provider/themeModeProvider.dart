import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  SharedPreferences _sharedPreferences;

  ThemeMode get themeMode => _themeMode;

  ThemeModeProvider() {
    _loadThemeModeFromPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    if (_sharedPreferences != null)
      return;
    
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void changeThemeMode(ThemeMode newThemeMode) {
    _themeMode = newThemeMode;
    _saveThemeModeToPreferences();

    notifyListeners();
  }

  Future<void> _loadThemeModeFromPreferences() async {
    await _initializeSharedPreferences();

    final int themeModeInt = _sharedPreferences.getInt("themeMode") ?? 0;
    _themeMode = ThemeMode.values.elementAt(themeModeInt);

    notifyListeners();
  }

  Future<void> _saveThemeModeToPreferences() async {
    await _initializeSharedPreferences();

    _sharedPreferences.setInt("themeMode", _themeMode.index);
  }
}