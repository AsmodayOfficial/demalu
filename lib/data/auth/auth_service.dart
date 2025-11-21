import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/api/api_config.dart';
import 'package:demalu/data/api/dio_client.dart';
import 'package:demalu/data/auth/storage_service.dart';
import 'package:dio/dio.dart';

class AuthService {
  final DioClient _dioClient = DioClient();
  final StorageService _storageService = StorageService.instance;

  // Логин
  Future<bool> login(String username, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.loginEndpoint,
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];


        await _storageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      colorLog('Login error: ${e.response?.data ?? e.message}', color: 'red');
      rethrow; 
    }
  }

  // Регистрация
  Future<bool> register(String username, String password, String phone) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.registerEndpoint,
        data: {"username": username, "password": password, "phone": phone},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Если бэкенд сразу возвращает токены после регистрации
        if (data['accessToken'] != null) {
          final accessToken = data['accessToken'];
          final refreshToken = data['refreshToken'];

          await _storageService.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      colorLog(
        'Register error: ${e.response?.data ?? e.message}',
        color: 'red',
      );
      rethrow;
    }
  }

  // Выход
  Future<void> logout() async {
    try {
      // Отправляем запрос на логаут (если требуется бэкендом)
      await _dioClient.dio.post(ApiConfig.logoutEndpoint);
    } catch (e) {
      colorLog("Logout error (ignoring): $e", color: 'red');
    } finally {
      // В любом случае удаляем токены локально
      await _storageService.clearTokens();
    }
  }
}
