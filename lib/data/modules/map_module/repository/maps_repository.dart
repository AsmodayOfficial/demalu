import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/modules/rooms_module/models/rooms_model.dart';
import 'package:dio/dio.dart';
import 'package:demalu/data/api/api_config.dart';
import 'package:demalu/data/api/dio_client.dart';

class MapsRepository {
  final DioClient _dioClient = DioClient();

  Future<List<Room>> getRooms() async {
    try {
      final response = await _dioClient.dio.get(ApiConfig.roomsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Room.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      colorLog("Error fetching rooms: ${e.message}", color: 'red');
      return [];
    }
  }

  Future<void> joinRoom(String pin) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.joinRoomEndpoint,
        data: {"pin": pin},
      );

      // 201 Created - Успешный вход
      if (response.statusCode == 201) {
        colorLog("Successfully joined room", color: 'green');
        return;
      }
    } on DioException catch (e) {
      // Обработка специфичных ошибок
      if (e.response?.statusCode == 404) {
        throw "Комната с таким PIN не найдена";
      } else if (e.response?.statusCode == 409) {
        throw "Вы уже находитесь в комнате. Сначала выйдите из текущей.";
      } else {
        colorLog("Join room error: ${e.response?.data}", color: 'red');
        throw "Ошибка подключения: ${e.message}";
      }
    }
  }

  Future<Room?> getMyRoom() async {
    try {
      final response = await _dioClient.dio.get(ApiConfig.myRoomEndpoint);
      if (response.statusCode == 200) {
        return Room.fromJson(response.data);
      }
    } catch (e) {
      // Если комнаты нет или ошибка - возвращаем null
      return null;
    }
    return null;
  }


  Future<void> leaveRoom() async {
    try {
      final response = await _dioClient.dio.delete(ApiConfig.leaveRoomEndpoint);

      // Обычно 200 или 204 означает успешное удаление/выход
      if (response.statusCode == 200 || response.statusCode == 204) {
        colorLog("Successfully left the room", color: 'green');
        return;
      }
    } on DioException catch (e) {
      colorLog("Error leaving room: ${e.response?.data}", color: 'red');
      throw "Не удалось выйти из комнаты: ${e.message}";
    }
  }
  
}
