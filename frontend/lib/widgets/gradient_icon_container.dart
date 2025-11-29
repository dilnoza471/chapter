import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_gradients.dart';
import '../theme/app_shadows.dart';

class GradientIconContainer extends StatelessWidget {
  final IconData icon;

  const GradientIconContainer({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.iconContainerSize,
      height: AppSpacing.iconContainerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.iconContainer),
        gradient: AppGradients.primary,
        boxShadow: AppShadows.soft,
      ),
      child: Icon(
        icon,
        size: AppSpacing.iconSize,
        color: Colors.white,
      ),
    );
  }
}