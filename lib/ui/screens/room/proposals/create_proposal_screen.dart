import 'package:demalu/data/modules/rooms_module/proposals_service/proposals_service.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:demalu/ui/widgets/base_page_wrapper.dart';
import 'package:demalu/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

// Вспомогательная функция для простого форматирования даты
String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
}

class CreateProposalScreen extends StatefulWidget {
  final int currentRoomId;
  const CreateProposalScreen({super.key, required this.currentRoomId});

  @override
  State<CreateProposalScreen> createState() => _CreateProposalScreenState();
}

class _CreateProposalScreenState extends State<CreateProposalScreen> {
  final _proposalService = ProposalsService();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  // НОВОЕ ПОЛЕ: Выбранная дата, инициализируем текущим днем
  DateTime _selectedDate = DateTime.now();

  bool _isSaving = false;

  // НОВЫЙ МЕТОД: Показать выбор даты
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // Нельзя выбрать прошедшую дату
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSave() async {
    // Обновляем валидацию
    if (_nameController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Заполните поля Название и Адрес"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _proposalService.createProposal(
        roomId: widget.currentRoomId,
        name: _nameController.text,
        address: _addressController.text,
        date: _selectedDate,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Предложение создано!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWrapper(
      title: 'Создание предложения',
      primaryButtonText: 'Сохранить',
      secondaryButtonText: 'Отмена',
      onPrimaryAction: _handleSave,
      onSecondaryAction: () => Navigator.of(context).pop(),
      isLoading: _isSaving,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: 'Название',
            hint: 'Введите название',
            controller: _nameController,
          ),

          const SizedBox(height: 24),

          CustomTextField(
            label: 'Адрес / Место',
            hint: 'Введите адрес или описание места',
            controller: _addressController,
          ),

          const SizedBox(height: 24),

          // НОВОЕ ПОЛЕ: Выбор даты
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Предлагаемая дата',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              // Отображаем выбранную дату
              child: Text(
                _formatDate(_selectedDate),
                // Использование стиля из стилей приложения для текста
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors
                      .textPrimary, // Убедимся, что цвет текста корректен
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
