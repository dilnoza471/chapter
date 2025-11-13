import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const _prefsKey = 'theme_mode_index';

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  // Call once at startup: await ThemeController().load();
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idx = prefs.getInt(_prefsKey);
      if (idx != null && idx >= 0 && idx < ThemeMode.values.length) {
        _mode = ThemeMode.values[idx];
      } else {
        _mode = ThemeMode.system;
      }
    } catch (_) {
      _mode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setMode(ThemeMode newMode) async {
    if (newMode == _mode) return;
    _mode = newMode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefsKey, newMode.index);
    } catch (_) {
      // ignore prefs errors
    }
  }
}
