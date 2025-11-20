import 'package:dio/dio.dart';
import 'api_config.dart';
import 'interceptor.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            responseType: ResponseType.json,
          ),
        ) {
    _dio.interceptors.add(CustomInterceptor(_dio));
  }

  Dio get dio => _dio;
}