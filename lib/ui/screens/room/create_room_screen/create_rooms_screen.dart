// ui/screens/room/create_room/create_room_screen.dart
import 'package:demalu/data/modules/rooms_module/rooms_service/rooms_service.dart';
import 'package:demalu/ui/widgets/base_page_wrapper.dart';
import 'package:flutter/material.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  // ИЗМЕНЕНИЕ: Устанавливаем значение '2' по умолчанию
  final _maxMembersController = TextEditingController(text: '2');
  
  final RoomsService _roomsService = RoomsService();
  bool _isPrivate = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Логика валидации остаётся прежней, она обработает '2' как валидное значение.
      final int maxMembers = int.tryParse(_maxMembersController.text.trim()) ?? 0;

      try {
        await _roomsService.createRoom(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          isPrivate: _isPrivate,
          maxMembers: maxMembers,
          maxDistance: 0,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Комната успешно создана!')),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWrapper(
      title: 'Создание комнаты',
      primaryButtonText: 'Создать',
      onPrimaryAction: _createRoom,
      secondaryButtonText: 'Отмена',
      isLoading: _isLoading,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название комнаты*',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите название комнаты';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание (необязательно)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Поле теперь отображает '2' по умолчанию
            TextFormField(
              controller: _maxMembersController,
              decoration: const InputDecoration(
                // Обновляем текст, чтобы отразить дефолтное значение 
                labelText: 'Макс. количество участников (По умолчанию: 2, 0 = без лимита)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите число или 0';
                }
                final number = int.tryParse(value.trim());
                if (number == null) {
                  return 'Должно быть целое число';
                }
                if (number < 0) {
                  return 'Число не может быть отрицательным';
                }
                if (number > 0 && number < 2) {
                  return 'Минимум 2 участника для установки лимита';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Приватная комната:'),
                Switch(
                  value: _isPrivate,
                  onChanged: _isLoading ? null : (value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}