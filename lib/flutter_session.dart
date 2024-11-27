import 'dart:convert';
import 'package:flutter/services.dart';

class Config {
  static Map<String, dynamic> _configData = {};
  static final String _fileName = 'config/main.json';

  static Future<Map<String, dynamic>> load() async {
    String configString = await rootBundle.loadString(_fileName);
    _configData = json.decode(configString);
    return _configData;
  }

  static Map<String, dynamic> getConfig() {
    return _configData;
  }

  static void set(String key, dynamic value) {
    _configData[key] = value;
  }

  static dynamic get(String key) {
    return _configData.containsKey(key) ? _configData[key] : null;
  }
}
