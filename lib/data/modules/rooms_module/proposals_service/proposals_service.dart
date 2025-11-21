import 'package:demalu/data/modules/rooms_module/prosponsal_repository/proposals_repository.dart';

class ProposalsService {
  final ProposalsRepository _repository = ProposalsRepository();

  Future<void> createProposal({
    required int roomId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    await _repository.createProposal(
      roomId: roomId,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }
}