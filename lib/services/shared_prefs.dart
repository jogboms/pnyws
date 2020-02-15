import 'dart:async' show Future;
import 'dart:convert' show json;

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs(this._preferences);

  final SharedPreferences _preferences;

  String getString(String key) => _preferences.getString(key) ?? '';

  Future<String> setString(String key, String value) async {
    await _preferences.setString(key, value);
    return value;
  }

  Map<String, dynamic> getMap(String key) {
    try {
      final _map = getString(key);
      return _map.isEmpty ? null : json.decode(_map);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> setMap(String key, Map<String, dynamic> value) async {
    await setString(key, json.encode(value));
    return value;
  }

  int getInt(String key) => _preferences.getInt(key);

  Future<int> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
    return value;
  }

  bool getBool(String key) => _preferences.getBool(key);

  Future<bool> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
    return value;
  }

  bool contains(String key) => _preferences.containsKey(key);

  Future<bool> remove(String key) => _preferences.remove(key);
}
