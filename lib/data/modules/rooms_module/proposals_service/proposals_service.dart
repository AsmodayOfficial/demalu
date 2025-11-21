// proposals_service.dart

import 'package:demalu/data/modules/rooms_module/models/proposals_model.dart';
import 'package:demalu/data/modules/rooms_module/prosponsal_repository/proposals_repository.dart';

class ProposalsService {
  final ProposalsRepository _repository = ProposalsRepository();

  Future<void> createProposal({
    required int roomId,
    required String name,
    required String address,
    required DateTime date, // Принимаем только выбранную дату
  }) async {
    // 1. Создаем дату начала дня (00:00:00)
    final proposedDateStart = DateTime(date.year, date.month, date.day);
    // 2. Создаем дату конца дня (23:59:59.999...)
    final proposedDateEnd = DateTime(date.year, date.month, date.day + 1).subtract(const Duration(milliseconds: 1));

    await _repository.createProposal(
      roomId: roomId,
      name: name,
      address: address,
      dateStart: proposedDateStart.toIso8601String(), // Отправляем начало
      dateEnd: proposedDateEnd.toIso8601String(),     // Отправляем конец
    );
  }

  Future<List<Proposal>> getProposals(int roomId) async {
    return await _repository.getRoomProposals(roomId);
  }

  Future<void> vote({
    required int proposalId,
    required bool isLike, // true = LIKE, false = DISLIKE
    String? comment,
  }) async {
    final response = isLike ? 'ACCEPT' : 'REJECT';
    await _repository.voteForProposal(
      proposalId: proposalId,
      response: response,
      comment: comment,
    );
  }
}