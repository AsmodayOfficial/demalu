import 'package:demalu/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:demalu/ui/widgets/custom_button.dart';
import 'package:demalu/ui/styles/styles.dart';

class BasePageWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final String primaryButtonText;
  final VoidCallback onPrimaryAction;
  final String secondaryButtonText;
  final VoidCallback? onSecondaryAction;
  final bool isLoading;

  const BasePageWrapper({
    super.key,
    required this.title,
    required this.child,
    required this.primaryButtonText,
    required this.onPrimaryAction,
    this.secondaryButtonText = 'Отмена',
    this.onSecondaryAction,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: title,
        textStyle: AppTextStyles.heading3.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: child,
              ),
            ),

            _buildFooter(context),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: secondaryButtonText,
              onTap: onSecondaryAction ?? () => Navigator.of(context).pop(),
              backgroundColor: Color(0xFFFF0443),
              textColor: AppColors.surface,
              borderRadius: 4,
              height: 48,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: primaryButtonText,
              onTap: onPrimaryAction,
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
              borderRadius: 4,
              isLoading: isLoading,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }
}
