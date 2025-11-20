import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  late SharedPreferences _prefs;

  final _keyAccessToken = 'access_token';
  final _keyRefreshToken = 'refresh_token';


  StorageService._internal();

  static StorageService get instance => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await _prefs.setString(_keyAccessToken, accessToken);
    await _prefs.setString(_keyRefreshToken, refreshToken ?? '');
  }

  Future<String?> getAccessToken() async {
    return _prefs.getString(_keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_keyRefreshToken);
  }

  Future<void> clearTokens() async {
    await _prefs.clear();
  }
}