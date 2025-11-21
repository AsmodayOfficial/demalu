import 'package:demalu/data/modules/map_module/service/maps_service.dart';
import 'package:demalu/data/modules/rooms_module/models/rooms_model.dart';
import 'package:demalu/ui/screens/room/widgets/room_card_widget.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:demalu/ui/widgets/custom_modal.dart'; // Убедитесь, что импорт есть
import 'package:flutter/material.dart';

class PublicRoomsScreen extends StatefulWidget {
  // Добавляем колбэк для переключения на карту при успехе
  final VoidCallback? onJoinSuccess; 

  const PublicRoomsScreen({super.key, this.onJoinSuccess});

  @override
  State<PublicRoomsScreen> createState() => _PublicRoomsScreenState();
}

class _PublicRoomsScreenState extends State<PublicRoomsScreen> {
  final MapsService _mapsService = MapsService();
  late Future<List<Room>> _roomsFuture;
  bool _isJoining = false; // Состояние загрузки при входе

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

  // ЛОГИКА ВХОДА В КОМНАТУ
  Future<void> _handleJoinRoom(String pin) async {
    
    setState(() => _isJoining = true);

    try {
      // Отправляем PIN на сервер
      await _mapsService.joinRoom(pin);

      if (!mounted) return;
      
      // Если успешно — переключаем на карту
      widget.onJoinSuccess?.call();
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  // Показ диалога подтверждения
  void _showJoinDialog(Room room) {
    showDialog(
      context: context,
      builder: (context) => CustomModal(
        title: room.name,
        content: 'Вы хотите войти в эту комнату?',
        confirmText: 'Войти',
        onConfirm: () => _handleJoinRoom(room.pin), // Передаем PIN выбранной комнаты
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Показываем глобальную загрузку, если идет процесс входа
    if (_isJoining) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<Room>>(
      future: _roomsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: _loadRooms,
              child: const Text("Ошибка. Повторить"),
            ),
          );
        }

        final rooms = snapshot.data ?? [];

        if (rooms.isEmpty) {
          return const Center(child: Text("Нет доступных комнат"));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text('Общее: ${rooms.length}', style: AppTextStyles.paragraph5),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: RoomCardWidget(
                      title: room.name,
                      subtitle: room.description,
                      countMembers: room.countMembers,
                      maxMembers: room.maxMembers,
                      // При нажатии вызываем диалог с PIN-кодом этой комнаты
                      onTap: () => _showJoinDialog(room),
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