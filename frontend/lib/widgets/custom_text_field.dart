import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData labelIcon;
  final String errorText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.labelIcon,
    this.errorText = '',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              labelIcon,
              size: AppSpacing.smallIconSize,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              labelText,
              style: AppTypography.label,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.fieldSpacing),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: AppTypography.input,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide(
                color: errorText.isNotEmpty
                    ? AppColors.destructive
                    : AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide(
                color: errorText.isNotEmpty
                    ? AppColors.destructive
                    : AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide(
                color: errorText.isNotEmpty
                    ? AppColors.destructive
                    : AppColors.primary,
                width: 2,
              ),
            ),
          ),
          onChanged: onChanged,
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText,
              style: AppTypography.error.copyWith(
                color: AppColors.destructive,
              ),
            ),
          ),
      ],
    );
  }
}