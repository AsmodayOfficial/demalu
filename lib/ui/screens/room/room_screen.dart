import 'package:demalu/core/color_log.dart';
import 'package:demalu/data/modules/map_module/service/maps_service.dart'; // Импорт сервиса
import 'package:demalu/ui/screens/room/create_room_screen/create_rooms_screen.dart';
import 'package:demalu/ui/screens/room/current_room/current_room_screen.dart';
import 'package:demalu/ui/screens/room/tab_rooms/private_rooms_screen.dart';
import 'package:demalu/ui/screens/room/tab_rooms/public_rooms_screen.dart';
import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:demalu/ui/widgets/custom_sliding_tabs.dart';
import 'package:flutter/material.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final MapsService _mapsService = MapsService();

  // Состояние: находимся ли мы в режиме карты (в комнате)
  bool _isMapMode = false;
  bool _isLoading = true; // Для первоначальной проверки

  @override
  void initState() {
    super.initState();
    _checkInitialRoomState();
  }

  // Проверяем при старте, находится ли юзер уже в комнате
  Future<void> _checkInitialRoomState() async {
    try {
      final room = await _mapsService.getMyRoom();
      if (room != null) {
        if (mounted) {
          setState(() {
            _isMapMode = true;
          });
        }
      }
    } catch (e) {
      print("Error checking room: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Метод для переключения на карту (передадим его в PrivateRoomsScreen)
  void _switchToMap() {
    setState(() {
      _isMapMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Если идет проверка, можно показать загрузку или пустой контейнер
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isMapMode) {
      return const CurrentRoomScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(title: 'Места рядом'),
      body: CustomSlidingTabs(
        firstTabScreen: PublicRoomsScreen(onJoinSuccess: _switchToMap),
        secondTabScreen: PrivateRoomsScreen(onJoinSuccess: _switchToMap),
        firstTabTitle: 'Публичные комнаты',
        secondTabTitle: 'Войти в комнату',
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 3,
        onPressed: () async {
          // Кнопка создания новой комнаты
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateRoomScreen(),
            ),
          );
          // Можно добавить логику обновления состояния после создания комнаты
          if (result == true) {
            // Например, обновить список комнат
            colorLog("Комната создана, можно обновить списки", color: 'green');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
