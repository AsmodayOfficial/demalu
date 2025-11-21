// data/modules/rooms_module/rooms_service/rooms_service.dart
import 'package:demalu/data/modules/rooms_module/rooms_repository/rooms_repository.dart';

class RoomsService {
  final RoomsRepository _repository = RoomsRepository();

  Future<void> createRoom({
    required String name,
    String? description,
    required bool isPrivate,
    int maxMembers = 0,
    int maxDistance = 0,
  }) async {
    await _repository.createRoom(
      name: name,
      description: description,
      isPrivate: isPrivate,
      maxMembers: maxMembers,
      maxDistance: maxDistance,
    );
  }
}