import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 4),
      spreadRadius: -4,
    ),
  ];

  static List<BoxShadow> strong = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.3),
      blurRadius: 40,
      offset: const Offset(0, 10),
      spreadRadius: -10,
    ),
  ];
}