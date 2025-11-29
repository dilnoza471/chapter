import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../widgets/gradient_icon_container.dart';
import '../widgets/gradient_text.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';

class IdEntryScreen extends StatefulWidget {
  const IdEntryScreen({super.key});

  @override
  State<IdEntryScreen> createState() => _IdEntryScreenState();
}

class _IdEntryScreenState extends State<IdEntryScreen> {
  final _studentIdController = TextEditingController();
  final _bookIdController = TextEditingController();
  String _studentIdError = '';
  String _bookIdError = '';

  @override
  void dispose() {
    _studentIdController.dispose();
    _bookIdController.dispose();
    super.dispose();
  }

  String _validateNumber(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return '$fieldName must contain only numbers';
    }
    return '';
  }

  void _handleSubmit() {
    setState(() {
      _studentIdError = _validateNumber(_studentIdController.text, 'Student ID');
      _bookIdError = _validateNumber(_bookIdController.text, 'Book ID');
    });

    if (_studentIdError.isEmpty && _bookIdError.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'IDs submitted successfully!\nStudent ID: ${_studentIdController.text}, Book ID: ${_bookIdController.text}',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      print('Submitted: Student ID: ${_studentIdController.text}, Book ID: ${_bookIdController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.background,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.containerPadding),
            child: Card(
              elevation: 0,
              color: AppColors.card.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.card),
                side: BorderSide(
                  color: AppColors.border.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: AppSpacing.cardMaxWidth),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Column(
                      children: [
                        const GradientIconContainer(icon: Icons.menu_book),
                        const SizedBox(height: AppSpacing.headerSpacing),
                        const GradientText(
                          text: 'Library System',
                          style: AppTypography.title,
                        ),
                        const SizedBox(height: AppSpacing.headerSpacing),
                        Text(
                          'Enter student and book identification numbers',
                          style: AppTypography.description.copyWith(
                            color: AppColors.foreground.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.formSpacing),
                    // Form
                    Column(
                      children: [
                        CustomTextField(
                          controller: _studentIdController,
                          hintText: 'Enter student ID',
                          labelText: 'Student ID',
                          labelIcon: Icons.person,
                          errorText: _studentIdError,
                          onChanged: (value) {
                            setState(() {
                              _studentIdError = '';
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.formSpacing),
                        CustomTextField(
                          controller: _bookIdController,
                          hintText: 'Enter book ID',
                          labelText: 'Book ID',
                          labelIcon: Icons.menu_book,
                          errorText: _bookIdError,
                          onChanged: (value) {
                            setState(() {
                              _bookIdError = '';
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.formSpacing),
                        GradientButton(
                          text: 'Submit',
                          onPressed: _handleSubmit,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}