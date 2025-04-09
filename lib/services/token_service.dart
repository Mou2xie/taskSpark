import 'package:hive_flutter/hive_flutter.dart';

class TokenService {
  static const String _tokenBoxName = 'tokenBox';
  static const String _tokenKey = 'token';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_tokenBoxName);
  }

  static Future<void> saveToken(String token) async {
    final box = Hive.box(_tokenBoxName);
    await box.put(_tokenKey, token);
  }

  static String? getToken() {
    final box = Hive.box(_tokenBoxName);
    return box.get(_tokenKey);
  }

  static Future<void> deleteToken() async {
    final box = Hive.box(_tokenBoxName);
    await box.delete(_tokenKey);
  }
} 