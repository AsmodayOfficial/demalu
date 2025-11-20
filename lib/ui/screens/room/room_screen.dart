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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(title: 'Места рядом'),
      body: CustomSlidingTabs(
        firstTabScreen: const PublicRoomsScreen(),
        secondTabScreen: const PrivateRoomsScreen(),
        firstTabTitle: 'Публичные комнаты',
        secondTabTitle: 'Войти в комнату',
      ),
    );
  }
}
