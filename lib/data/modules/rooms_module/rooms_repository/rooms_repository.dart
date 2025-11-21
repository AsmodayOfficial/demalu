// data/modules/rooms_module/rooms_repository/rooms_repository.dart
import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/api/api_config.dart';
import 'package:demalu/data/api/dio_client.dart';
import 'package:dio/dio.dart';

class RoomsRepository {
  final DioClient _dioClient = DioClient();

  Future<void> createRoom({
    required String name,
    String? description,
    required bool isPrivate,
    required int maxMembers,
    required int maxDistance,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.roomsEndpoint,
        data: {
          "name": name,
          "description": description,
          "isPrivate": isPrivate,
          "maxMembers": maxMembers,
          "maxDistance": maxDistance,
        },
      );

      if (response.statusCode == 201) {
        colorLog("Room created successfully!", color: 'green');
        return;
      }
      throw "Неизвестная ошибка создания комнаты";
      
    } on DioException catch (e) {
      colorLog("Room creation error: ${e.response?.data ?? e.message}", color: 'red');
      // В зависимости от ответа сервера
      throw "Ошибка: ${e.response?.data['message'] ?? 'Не удалось создать комнату.'}";
    }
  }
}