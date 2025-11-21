import 'package:demalu/data/modules/rooms_module/proposals_service/proposals_service.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:demalu/ui/widgets/base_page_wrapper.dart';
import 'package:demalu/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CreateProposalScreen extends StatefulWidget {
  final int currentRoomId;
  const CreateProposalScreen({super.key, required this.currentRoomId});

  @override
  State<CreateProposalScreen> createState() => _CreateProposalScreenState();
}

class _CreateProposalScreenState extends State<CreateProposalScreen> {
  final _proposalService = ProposalsService(); // Инициализация сервиса
  
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  // Добавим контроллер для выбора места (заглушка)
  String? _selectedPlace; 

  bool _isSaving = false;

  void _handleSave() async {
    if (_nameController.text.isEmpty || _addressController.text.isEmpty || _selectedPlace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Заполните все обязательные поля"),
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
        latitude: 0.0, 
        longitude: 0.0,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Предложение создано!"), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
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
      onSecondaryAction: () => Navigator.of(context).pop(), // Отмена
      isLoading: _isSaving,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text('Место', style: AppTextStyles.bodyLarge), // Стиль для Label
          // const SizedBox(height: 8),
          // DropdownButtonFormField(
          //   value: 'Выберите место',
          //   items: const [
          //     DropdownMenuItem(value: 'Выберите место', child: Text('Выберите место')),
          //   ],
          //   onChanged: (value) {},
          //   decoration: InputDecoration(
          //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          //   ),
          // ),
          //const SizedBox(height: 24),

          // 2. Название
          CustomTextField(
            label: 'Название',
            hint: 'Введите название',
            controller: _nameController,
          ),

          const SizedBox(height: 24),

          // 3. Адрес
          CustomTextField(
            label: 'Адрес',
            hint: 'Введите адрес',
            controller: _addressController,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
