import 'package:flutter/material.dart';

class PrivateRoomsScreen extends StatefulWidget {
  const PrivateRoomsScreen({super.key});

  @override
  State<PrivateRoomsScreen> createState() => _PrivateRoomsScreenState();
}

class _PrivateRoomsScreenState extends State<PrivateRoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Здесь ввод кода комнаты"));
  }
}
