import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Chamadas para o sharedPreferences
class Store {
  // Salvar uma string dentro do shared preferences
  static Future<bool> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  // Salvar um map
  static Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    return saveString(key, jsonEncode(value));
  }

  // Ler uma string persistida dentro do dispositivo
  static Future<String> getString(String key,
      [String defaultValue = ""]) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  // Obter um map
  static Future<Map<String, dynamic>> getMap(String key) async {
    try {
      return jsonDecode(await getString(key));
    } catch (_) {
      return {};
    }
  }

  // Remove os dados
  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
