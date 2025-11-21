import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/api/api_config.dart';
import 'package:demalu/data/api/dio_client.dart';
import 'package:demalu/data/modules/rooms_module/models/proposals_model.dart';
import 'package:dio/dio.dart';

class ProposalsRepository {
  final DioClient _dioClient = DioClient();

  Future<void> createProposal({
    required int roomId,
    required String name,
    required String address,
    required String dateStart, // Начало диапазона
    required String dateEnd, // Конец диапазона
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConfig.proposalsEndpoint,
        data: {
          "roomId": roomId,
          "placeId": 0,
          "proposedName": name,
          "proposedAddress": address,
          "proposedDateStart": dateStart, 
          "proposedDateEnd": dateEnd,
        },
      );

      if (response.statusCode == 201) {
        colorLog("Proposal created successfully!", color: 'green');
        return;
      }
      throw "Неизвестная ошибка создания предложения";
      
    } on DioException catch (e) {
      colorLog("Proposal creation error: ${e.response?.data ?? e.message}", color: 'red');
      throw "Ошибка создания предложения: ${e.message}";
    }
  }

  Future<List<Proposal>> getRoomProposals(int roomId) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConfig.proposalsEndpoint, // Например: /api/v1/proposals/room/123
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Proposal.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      colorLog("Error fetching proposals: ${e.message}", color: 'red');
      return [];
    }
  }
  
  Future<void> voteForProposal({
    required int proposalId,
    required String response,
    String? comment,
  }) async {
    try {
      final voteEndpoint = '${ApiConfig.proposalsEndpoint}/$proposalId/vote';
      final payload = {
        "response": response,
        "comment": comment,
      };

      final apiResponse = await _dioClient.dio.post(
        voteEndpoint,
        data: payload,
      );

      if (apiResponse.statusCode == 200 || apiResponse.statusCode == 201) {
        colorLog("Successfully voted on proposal $proposalId", color: 'green');
        return;
      }
      throw "Не удалось проголосовать.";

    } on DioException catch (e) {
      colorLog("Error voting on proposal: ${e.response?.data ?? e.message}", color: 'red');
      throw "Ошибка голосования: ${e.response?.data['message'] ?? e.message}";
    }
  }
}