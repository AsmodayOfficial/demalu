import 'package:demalu/data/modules/rooms_module/models/proposals_model.dart';
import 'package:demalu/ui/styles/styles.dart';
import 'package:flutter/material.dart';

// Вспомогательная функция для форматирования даты и времени
String _formatDateTimeRange(DateTime start, DateTime end) {
  final startTime = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
  final endTime = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  final date = '${start.day.toString().padLeft(2, '0')}.${start.month.toString().padLeft(2, '0')}.${start.year}';
  
  // Если время начала и конца совпадают (то есть указана только дата), показываем только дату
  if (start.hour == end.hour && start.minute == end.minute) {
    return date;
  }
  return '$date ($startTime - $endTime UTC)'; 
}

class ProposalDetailsModal extends StatelessWidget {
  final Proposal proposal;

  const ProposalDetailsModal({super.key, required this.proposal});

  // Вспомогательные методы теперь являются методами экземпляра
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Увеличил ширину для меток
            child: Text(label, style: AppTextStyles.paragraph3.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.paragraph3),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteBadge(IconData icon, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: AppTextStyles.paragraph3.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // В API приходит proposedDateStart, но в модели мы сохраняли его как proposedDate.
    // Если вам нужна proposedDateEnd, нужно обновить модель, 
    // но пока используем заглушку, чтобы код скомпилировался.
    final DateTime proposedDateEndPlaceholder = proposal.proposedDate.add(const Duration(hours: 4));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Заголовок
          Text(
            proposal.proposedName,
            style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Дата и Время
                  _buildInfoRow(
                    'Дата:',
                    _formatDateTimeRange(
                      proposal.proposedDate,
                      proposedDateEndPlaceholder,
                    ),
                  ),

                  // Адрес
                  _buildInfoRow('Адрес:', proposal.proposedAddress),

                  // Предложил
                  _buildInfoRow('Предложил:', proposal.proposerUsername),

                  // Голосование
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: [
                        _buildVoteBadge(Icons.thumb_up, proposal.likes, AppColors.primary),
                        const SizedBox(width: 8),
                        _buildVoteBadge(Icons.thumb_down, proposal.dislikes, Colors.red),
                      ],
                    ),
                  ),

                  // Детали (Description/Details)
                  Text('Детали:', style: AppTextStyles.heading4),
                  const SizedBox(height: 4),
                  Text(proposal.details ?? 'Детали не указаны.', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 20),

                  // Прогноз Погоды
                  Text('Прогноз погоды (whether):', style: AppTextStyles.heading4),
                  const SizedBox(height: 4),
                  Text(proposal.whether ?? 'Нет данных о погоде.', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 20),

                  // Оценка Gemini
                  Text('Оценка Gemini (prediction):', style: AppTextStyles.heading4),
                  const SizedBox(height: 4),
                  Text(proposal.prediction ?? 'Нет оценки.', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}