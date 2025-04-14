import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class ThemeService {
  static const String _boxName = 'theme_box';
  static const String _isDarkModeKey = 'is_dark_mode';
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  static bool get isDarkMode => _box.get(_isDarkModeKey, defaultValue: false);

  static Future<void> setDarkMode(bool value) async {
    await _box.put(_isDarkModeKey, value);
  }
} 