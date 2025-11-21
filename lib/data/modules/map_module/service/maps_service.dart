import 'package:demalu/data/modules/map_module/repository/maps_repository.dart';
import 'package:demalu/data/modules/rooms_module/models/rooms_model.dart';

class MapsService {
  final MapsRepository _mapsRepository = MapsRepository();

  Future<List<Room>> getRooms() async {
    return await _mapsRepository.getRooms();
  }
  
  Future<List<Room>> getPublicRoomsOnly() async {
    final allRooms = await _mapsRepository.getRooms();
    return allRooms.where((room) => !room.isPrivate).toList();
  }

  Future<void> joinRoom(String pin) async {
    await _mapsRepository.joinRoom(pin);
  }

  Future<Room?> getMyRoom() async {
    return await _mapsRepository.getMyRoom();
  }

  Future<void> leaveRoom() async {
    await _mapsRepository.leaveRoom();
  }
}