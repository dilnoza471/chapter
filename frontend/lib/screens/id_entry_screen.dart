import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  // accept optional incoming ISBN so the Book ID field can be pre-filled
  final String? bookIsbn;

  const IdEntryScreen({super.key, this.bookIsbn});

  @override
  State<IdEntryScreen> createState() => _IdEntryScreenState();
}

class _IdEntryScreenState extends State<IdEntryScreen> {
  final _studentIdController = TextEditingController();
  final _bookIsbnController = TextEditingController();
  String _studentIdError = '';
  String _bookIsbnError = '';

  @override
  void dispose() {
    _studentIdController.dispose();
    _bookIsbnController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // prefill book/ISBN field if provided
    if (widget.bookIsbn != null && widget.bookIsbn!.isNotEmpty) {
      _bookIsbnController.text = widget.bookIsbn!.trim();
    }
  }

  String _validateNumber(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    // allow ISBN-ish values: digits, hyphens and 'X' (ISBN10)
    if (!RegExp(r'^[\d\-Xx]+$').hasMatch(value)) {
      return '$fieldName must be a valid ISBN (digits, hyphens, or X)';
    }
    return '';
  }

  Future<void> _handleSubmit() async {
    final baseUrl = "https://chapter-djfj.onrender.com";
    setState(() {
      _studentIdError = _validateNumber(
        _studentIdController.text,
        'Student ID',
      );
      _bookIsbnError = _validateNumber(_bookIsbnController.text, 'Book ID');
    });

    if (_studentIdError.isEmpty && _bookIsbnError.isEmpty) {
      final response = await http.post(
        Uri.parse('$baseUrl/borrow'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          // send the actual text and numeric student_id
          'book_isbn': _bookIsbnController.text.trim(),
          'student_id': int.parse(_studentIdController.text.trim()),
        }),
      );
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submission failed: Response body: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'IDs submitted successfully!\nStudent ID: ${_studentIdController.text}, Book ID: ${_bookIsbnController.text}',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      print(
        'Submitted: Student ID: ${_studentIdController.text}, Book ID: ${_bookIsbnController.text}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.background),
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
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.cardMaxWidth,
                ),
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
                          controller: _bookIsbnController,
                          hintText: 'Enter book ISBN',
                          labelText: 'Book ISBN',
                          labelIcon: Icons.menu_book,
                          errorText: _bookIsbnError,
                          onChanged: (value) {
                            setState(() {
                              _bookIsbnError = '';
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
