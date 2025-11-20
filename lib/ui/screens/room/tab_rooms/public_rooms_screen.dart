
import 'package:demalu/data/modules/map_module/service/maps_service.dart';
import 'package:demalu/data/modules/rooms_module/models/rooms_model.dart';
import 'package:demalu/ui/screens/room/widgets/room_card_widget.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:flutter/material.dart';

class PublicRoomsScreen extends StatefulWidget {
  const PublicRoomsScreen({super.key});

  @override
  State<PublicRoomsScreen> createState() => _PublicRoomsScreenState();
}

class _PublicRoomsScreenState extends State<PublicRoomsScreen> {
  final MapsService _mapsService = MapsService();
  late Future<List<Room>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    setState(() {
      _roomsFuture = _mapsService.getRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Room>>(
      future: _roomsFuture,
      builder: (context, snapshot) {
        // 1. Состояние загрузки
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Обработка ошибок
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ошибка загрузки данных"),
                TextButton(
                  onPressed: _loadRooms, // Кнопка "Повторить"
                  child: const Text("Повторить"),
                ),
              ],
            ),
          );
        }

        final rooms = snapshot.data ?? [];

        // 3. Если список пуст
        if (rooms.isEmpty) {
          return const Center(child: Text("Нет доступных комнат"));
        }

        // 4. Отображение списка
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Общее: ${rooms.length}', 
                    style: AppTextStyles.paragraph5,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                padding: const EdgeInsets.only(bottom: 20), // Отступ снизу списка
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0), // Отступ между карточками
                    child: RoomCardWidget(
                      title: room.name,
                      subtitle: room.description ?? "Нет описания",
                      countMembers: room.countMembers,
                      maxMembers: room.maxMembers,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}