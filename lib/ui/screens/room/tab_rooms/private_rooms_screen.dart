import 'package:demalu/data/modules/map_module/service/maps_service.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:demalu/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PrivateRoomsScreen extends StatefulWidget {
  // Добавляем колбэк, который вызовем при успешном входе
  final VoidCallback? onJoinSuccess;

  const PrivateRoomsScreen({super.key, this.onJoinSuccess});

  @override
  State<PrivateRoomsScreen> createState() => _PrivateRoomsScreenState();
}

class _PrivateRoomsScreenState extends State<PrivateRoomsScreen> {
  final MapsService _mapsService = MapsService();
  final TextEditingController _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleJoinRoom() async {
    final pin = _pinController.text.trim();

    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Введите PIN код"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _mapsService.joinRoom(pin);

      if (!mounted) return;

      // ВМЕСТО Navigator.push МЫ ВЫЗЫВАЕМ КОЛБЭК
      widget.onJoinSuccess?.call(); 
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );

      if (e.toString().contains("Вы уже находитесь в комнате")) {
        // Тут тоже вызываем колбэк, так как пользователь уже там
        widget.onJoinSuccess?.call();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Введите PIN комнаты', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            const Text(
              'Получите код у создателя комнаты',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Введите PIN',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              onTap: _handleJoinRoom,
              text: 'Войти в комнату',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}