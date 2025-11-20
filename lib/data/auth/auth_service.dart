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
        data: {
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];

        // Сохраняем токены
        await _storageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      // Можно добавить обработку конкретных ошибок (401, 400 и т.д.)
      print('Login error: ${e.response?.data ?? e.message}');
      rethrow; // Пробрасываем ошибку, чтобы показать Snackbar в UI
    }
  }

  // Регистрация
  Future<bool> register(String username, String password, String phone) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.registerEndpoint,
        data: {
          "username": username,
          "password": password,
          "phone": phone,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        // Если бэкенд сразу возвращает токены после регистрации
        if (data['access_token'] != null) {
           final accessToken = data['access_token'];
           final refreshToken = data['refresh_token'];
           
           await _storageService.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Register error: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  // Выход
  Future<void> logout() async {
    try {
      // Отправляем запрос на логаут (если требуется бэкендом)
      await _dioClient.dio.post(ApiConfig.logoutEndpoint);
    } catch (e) {
      print("Logout error (ignoring): $e");
    } finally {
      // В любом случае удаляем токены локально
      await _storageService.clearTokens();
    }
  }
}