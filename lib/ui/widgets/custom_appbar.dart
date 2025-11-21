import 'package:demalu/ui/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  TextStyle? textStyle;
  List<Widget>? actions;
  CustomAppBar({required this.title, this.textStyle, this.actions, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: textStyle ?? AppTextStyles.heading2),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.primary,
            size: 28,
          ),
          onPressed: () {
            // Действие при нажатии на кнопку поиска
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
