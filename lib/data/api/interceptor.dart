import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class CustomInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;

  CustomInterceptor(this.dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    
    options.headers['Accept'] = 'application/json';

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final newAccessToken = await _refreshToken();
        
        if (newAccessToken != null) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final response = await dio.fetch(options);
          
          _isRefreshing = false;
          return handler.resolve(response);
        } else {
          _isRefreshing = false;
          return handler.next(err);
        }
      } catch (e) {
        _isRefreshing = false;
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<String?> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null) return null;

    try {
      final tokenDio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      
      final response = await tokenDio.post(
        ApiConfig.refreshEndpoint, 
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        await prefs.setString('access_token', newAccessToken);
        if (newRefreshToken != null) {
          await prefs.setString('refresh_token', newRefreshToken);
        }

        return newAccessToken;
      }
    } catch (e) {
      await prefs.clear(); 
    }
    return null;
  }
}