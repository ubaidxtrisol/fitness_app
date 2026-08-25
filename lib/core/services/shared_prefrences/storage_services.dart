import 'package:shared_preferences/shared_preferences.dart';

part 'prefs_keys.dart';

/// A singleton class to manage local storage using SharedPreferences.
/// This class provides methods to set and get string, boolean, and list values.
/// It also provides a method to remove a value from storage.
///
/// Usage:
/// ```dart
/// final storage = StorageService.instance;
/// await storage.setString('key', 'value');
/// String value = storage.getString('key');
/// ```
/// This class is designed to be used as a singleton, ensuring that only one instance
/// of the class is created throughout the app's lifecycle. The `init` method
/// initializes the SharedPreferences instance, and should be called before using
/// any other methods.
//// Example:
final storage = StorageService.instance;

class StorageService {
  StorageService._privateConstructor();

  static final StorageService _instance = StorageService._privateConstructor();

  static StorageService get instance => _instance;
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  int getInt(String key) {
    return _prefs.getInt(key) ?? 0;
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  List<String> getList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
}
