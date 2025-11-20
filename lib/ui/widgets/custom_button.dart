import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.height = 56.0,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 16.0,
    this.border,
    this.textStyle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      color: textColor ?? theme.colorScheme.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    style: textStyle ??
                        theme.textTheme.titleMedium?.copyWith(
                          color: textColor ?? theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}