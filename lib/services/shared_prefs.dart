import 'dart:async' show Future;

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs(this._preferences);

  final SharedPreferences _preferences;

  String getString(String key) => _preferences.getString(key) ?? '';

  Future<String> setString(String key, String value) async {
    await _preferences.setString(key, value);
    return value;
  }

  bool getBool(String key) => _preferences.getBool(key) == false;

  Future<bool> setBool(String key, {required bool value}) async {
    await _preferences.setBool(key, value);
    return value;
  }

  Future<bool> remove(String key) => _preferences.remove(key);
}
