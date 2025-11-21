import 'dart:async';
import 'package:dio/dio.dart';
import 'package:demalu/data/api/api_config.dart';
import 'package:demalu/data/auth/storage_service.dart'; // Импорт вашего сервиса

class CustomInterceptor extends Interceptor {
  final Dio dio;
  
  // Флаг обновления
  bool _isRefreshing = false;
  
  // Очередь для запросов, которые пришли во время обновления токена
  final List<Map<String, dynamic>> _failedRequests = [];

  CustomInterceptor(this.dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    
    final accessToken = await StorageService.instance.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;

      // Если обновление УЖЕ идет, ставим этот запрос в очередь ожидания
      if (_isRefreshing) {
        final completer = Completer<Response>();
        _failedRequests.add({
          'options': options,
          'handler': handler,
          'completer': completer
        });
        return; // Не возвращаем ошибку, ждем
      }

      _isRefreshing = true;

      try {
        // Пытаемся обновить токен
        final newAccessToken = await _refreshToken();

        if (newAccessToken != null) {
          // 1. Повторяем текущий (первый упавший) запрос с новым токеном
          options.headers['Authorization'] = 'Bearer $newAccessToken';
          final response = await dio.fetch(options);
          
          // 2. Обрабатываем очередь других запросов, которые ждали
          _processQueue(newAccessToken);

          _isRefreshing = false;
          return handler.resolve(response);
        } else {
          _rejectQueue(err);
          _isRefreshing = false;
          return handler.next(err);
        }
      } catch (e) {
        _rejectQueue(err);
        _isRefreshing = false;
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  // Метод для повторной отправки запросов из очереди
  void _processQueue(String newToken) {
    for (var requestMap in _failedRequests) {
      final RequestOptions options = requestMap['options'];
      final ErrorInterceptorHandler handler = requestMap['handler'];

      options.headers['Authorization'] = 'Bearer $newToken';

      dio.fetch(options).then((response) {
        handler.resolve(response);
      }).catchError((e) {
        handler.next(e);
      });
    }
    _failedRequests.clear();
  }

  // Метод для отмены очереди, если рефреш не удался
  void _rejectQueue(DioException err) {
    for (var requestMap in _failedRequests) {
      final ErrorInterceptorHandler handler = requestMap['handler'];
      handler.next(err);
    }
    _failedRequests.clear();
  }

  Future<String?> _refreshToken() async {
    // Берем токен через сервис
    final refreshToken = await StorageService.instance.getRefreshToken();

    if (refreshToken == null) return null;

    try {
      // Создаем чистый Dio, чтобы не зациклить интерсепторы
      final tokenDio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      
      final response = await tokenDio.post(
        ApiConfig.refreshEndpoint, 
        data: {'refreshToken': refreshToken}, 
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Проверяем ключи, которые приходят с бэкенда
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken']; // Может быть null, если бэк не ротирует рефреш

        // Сохраняем через сервис!
        await StorageService.instance.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken ?? refreshToken, // Если новый рефреш не пришел, оставляем старый
        );

        return newAccessToken;
      }
    } catch (e) {
      // Если рефреш не удался - разлогиниваем пользователя
      await StorageService.instance.clearTokens();
    }
    return null;
  }
}