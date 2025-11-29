import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.primaryLight,
    ],
  );

  static LinearGradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.background,
      AppColors.secondary.withOpacity(0.3),
      AppColors.background,
    ],
  );

  static LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const HSLColor.fromAHSL(1.0, 12, 0.88, 0.65).toColor(),
      const HSLColor.fromAHSL(1.0, 25, 0.95, 0.70).toColor(),
    ],
  );
}
