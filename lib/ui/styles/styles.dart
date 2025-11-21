// lib/ui/theme/styles.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF47A6EE);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color error = Color(0xFFB00020);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
  static const Color grayLight = Color(0xFF808080);

  static final Color border = Colors.grey.shade200;
  static final Color hint = Colors.grey.shade400;
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppBorderRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
}

class AppTextStyles {
  // Заголовки (Headline)
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold, // w700
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Подзаголовки (Title)
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading5 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle paragraph1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.grayLight,
    height: 1.2,
  );

  static const TextStyle paragraph2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.grayLight,
    height: 1.2,
  );

  static const TextStyle paragraph3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.grayLight,
    height: 1.2,
  );

  static const TextStyle paragraph4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.grayLight,
    height: 1.2,
  );

  static const TextStyle paragraph5 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600, // w600
    color: AppColors.grayLight,
    height: 1.2,
  );

  // Основной текст (Body)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal, // w400
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Второстепенный текст (Caption/Small)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Текст на кнопках
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}
