import 'package:flutter/material.dart';
import 'package:demalu/ui/styles/styles.dart'; // Ваши стили

class CustomModal extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final VoidCallback onConfirm;
  final String cancelText;

  const CustomModal({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText = 'Войти',
    this.cancelText = 'Отмена',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Закругленные края
      ),
      elevation: 0,
      backgroundColor: Colors.transparent, // Прозрачный фон самого диалога
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Размер по содержимому
          children: <Widget>[
            // Иконка или заголовок
            Text(
              title,
              style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Текст описания
            Text(
              content,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Кнопки
            Row(
              children: [
                // Кнопка Отмены
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      cancelText,
                      style: AppTextStyles.button.copyWith(color: AppColors.grayLight),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Кнопка Действия (Primary)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.of(context).pop(); // Закрыть после действия
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmText,
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}