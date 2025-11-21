import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/api/api_config.dart';
import 'package:demalu/data/api/dio_client.dart';
import 'package:dio/dio.dart';

class ProposalsRepository {
  final DioClient _dioClient = DioClient();

  Future<void> createProposal({
    required int roomId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    // Добавьте остальные параметры по мере необходимости
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.proposalsEndpoint,
        data: {
          "roomId": roomId,
          "placeId": 0, // Предполагаем 0, если место новое
          "proposedName": name,
          "proposedAddress": address,
          "proposedLatitude": latitude,
          "proposedLongitude": longitude,
        },
      );

      if (response.statusCode == 201) {
        colorLog("Proposal created successfully!", color: 'green');
        return;
      }
      throw "Неизвестная ошибка создания предложения";
      
    } on DioException catch (e) {
      colorLog("Proposal creation error: ${e.response?.data ?? e.message}", color: 'red');
      // В зависимости от ответа сервера (400 Bad Request, 403 Forbidden)
      throw "Ошибка: ${e.response?.data['message'] ?? 'Не удалось создать предложение.'}";
    }
  }
}