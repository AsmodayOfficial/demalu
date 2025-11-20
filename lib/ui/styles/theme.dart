// lib/ui/theme/theme.dart
import 'package:flutter/material.dart';
import 'styles.dart'; // ОБЯЗАТЕЛЬНО импортируем styles.dart

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'InterDisplay',

      // Берем цвета из AppColors
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: AppColors.background,

      textTheme: TextTheme(
        // Для заголовков экранов (heading1)
        headlineMedium: AppTextStyles.heading1, 
        
        // Для подзаголовков или названий секций (heading2)
        titleLarge: AppTextStyles.heading2,
        
        // Основной текст (bodyLarge)
        bodyLarge: AppTextStyles.bodyLarge,
        
        // Второстепенный текст (bodySmall)
        bodySmall: AppTextStyles.bodySmall,
        
        // Текст на кнопках (button)
        labelLarge: AppTextStyles.button,
      ).apply(
        // Гарантируем, что ваш шрифт применится ко всем стилям
        fontFamily: 'InterDisplay',
        // Устанавливаем базовые цвета для текста
        bodyColor: AppColors.textPrimary, 
        displayColor: AppColors.textPrimary,
      ),

      // 1. AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'InterDisplay',
        ),
      ),

      // 2. Кнопки
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'InterDisplay',
          ),
          elevation: 0,
        ),
      ),

      // 3. Поля ввода
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md + 4, // 20
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          borderSide: BorderSide(color: AppColors.border),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: AppColors.hint),
      ),

      // 4. Навигация
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.hint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}