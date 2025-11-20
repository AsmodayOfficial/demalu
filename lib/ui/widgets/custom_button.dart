import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final bool isLoading;
  final Widget? icon;

  const CustomButton({
    super.key,
    this.text,
    required this.onTap,
    this.width,
    this.height = 56.0,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 16.0,
    this.border,
    this.textStyle,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentColor = textColor ?? theme.colorScheme.onPrimary;

    // Проверяем, есть ли текст
    final bool hasText = text != null && text!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: contentColor,
                      strokeWidth: 2,
                    ),
                  )
                : IconTheme(
                    data: IconThemeData(color: contentColor, size: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) icon!,

                        // ИСПРАВЛЕНИЕ: Добавляем отступ ТОЛЬКО если есть и иконка, и текст
                        if (icon != null && hasText) const SizedBox(width: 8),

                        if (hasText)
                          Text(
                            text!,
                            style:
                                textStyle ??
                                theme.textTheme.titleMedium?.copyWith(
                                  color: contentColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
