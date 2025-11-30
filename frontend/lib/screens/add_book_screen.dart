import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _isbnController = TextEditingController();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _languageController = TextEditingController();
  final _categoryController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _totalCopiesController = TextEditingController(text: '1');
  final _availableCopiesController = TextEditingController(text: '1');

  DateTime _publicationDate = DateTime.now();
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;

  final String _apiBaseUrl =
      'https://chapter-djfj.onrender.com'; // Change to your API URL

  @override
  void dispose() {
    _isbnController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _languageController.dispose();
    _categoryController.dispose();
    _coverUrlController.dispose();
    _totalCopiesController.dispose();
    _availableCopiesController.dispose();
    super.dispose();
  }

  // Fetch book info from ISBN
  Future<void> _searchByISBN() async {
    if (_isbnController.text.trim().isEmpty) {
      _showError('Please enter an ISBN');
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/books/isbn/${_isbnController.text.trim()}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _titleController.text = data['title'] ?? '';
          _authorController.text = data['author'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _languageController.text = data['language'] ?? 'en';
          _categoryController.text = data['category'] ?? '';
          _coverUrlController.text = data['coverImageUrl'] ?? '';

          // Parse publication date
          if (data['publicationDate'] != null &&
              data['publicationDate'].isNotEmpty) {
            try {
              _publicationDate = DateTime.parse(data['publicationDate']);
            } catch (e) {
              _publicationDate = DateTime.now();
            }
          }
        });

        _showSuccess('Book information loaded successfully!');
      } else if (response.statusCode == 404) {
        _showError('Book not found. Please enter details manually.');
      } else {
        _showError('Failed to fetch book information');
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // Create book in database
  Future<void> _createBook() async {
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bookData = {
        'isbn': _isbnController.text.trim(),
        'title': _titleController.text.trim(),
        'author': _authorController.text.trim(),
        'description': _descriptionController.text.trim(),
        'publicationDate': _publicationDate.toIso8601String(),
        'language': _languageController.text.trim(),
        'category': _categoryController.text.trim(),
        'coverImageUrl': _coverUrlController.text.trim(),
        'totalCopies': int.parse(_totalCopiesController.text),
        'availableCopies': int.parse(_availableCopiesController.text),
      };

      print('Sending request to: $_apiBaseUrl/books');
      print('Book data: $bookData');

      final response = await http.post(
        Uri.parse('$_apiBaseUrl/books'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bookData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccess('Book created successfully!');
        _clearForm();
        // Don't pop if testing standalone
        // Navigator.pop(context, true);
      } else {
        final error = json.decode(response.body);
        _showError(error['error'] ?? 'Failed to create book');
      }
    } catch (e) {
      print('Error caught: $e');
      _showError('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _isbnController.clear();
    _titleController.clear();
    _authorController.clear();
    _descriptionController.clear();
    _languageController.clear();
    _categoryController.clear();
    _coverUrlController.clear();
    _totalCopiesController.text = '1';
    _availableCopiesController.text = '1';
    _publicationDate = DateTime.now();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.destructive),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.primary),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _publicationDate,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _publicationDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add New Book'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.cardMaxWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ISBN Search Card
                    Container(
                      padding: const EdgeInsets.all(
                        AppSpacing.containerPadding,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Add by ISBN',
                            style: AppTypography.title.copyWith(
                              color: AppColors.foreground,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.headerSpacing),
                          Text(
                            'Enter ISBN to auto-fill book information',
                            style: AppTypography.description.copyWith(
                              color: AppColors.foreground.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.formSpacing),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _isbnController,
                                  decoration: InputDecoration(
                                    labelText: 'ISBN',
                                    hintText: 'e.g., 9780140328721',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.input,
                                      ),
                                      borderSide: BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.input,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter ISBN';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                height: AppSpacing.inputHeight,
                                child: ElevatedButton(
                                  onPressed: _isSearching
                                      ? null
                                      : _searchByISBN,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor:
                                        AppColors.primaryForeground,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.button,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                  ),
                                  child: _isSearching
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Icon(Icons.search),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.formSpacing),

                    // Book Details Card
                    Container(
                      padding: const EdgeInsets.all(
                        AppSpacing.containerPadding,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        boxShadow: AppShadows.soft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book Details',
                            style: AppTypography.title.copyWith(
                              color: AppColors.foreground,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.formSpacing),

                          // Title
                          _buildTextField(
                            controller: _titleController,
                            label: 'Title',
                            hint: 'Enter book title',
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),

                          const SizedBox(height: AppSpacing.fieldSpacing * 2),

                          // Author
                          _buildTextField(
                            controller: _authorController,
                            label: 'Author',
                            hint: 'Enter author name',
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),

                          const SizedBox(height: AppSpacing.fieldSpacing * 2),

                          // Description
                          _buildTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            hint: 'Enter book description',
                            maxLines: 4,
                          ),

                          const SizedBox(height: AppSpacing.fieldSpacing * 2),

                          // Publication Date
                          InkWell(
                            onTap: _selectDate,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Publication Date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.input,
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                filled: true,
                                fillColor: AppColors.input,
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: AppColors.primary,
                                ),
                              ),
                              child: Text(
                                '${_publicationDate.year}-${_publicationDate.month.toString().padLeft(2, '0')}-${_publicationDate.day.toString().padLeft(2, '0')}',
                                style: AppTypography.input,
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.fieldSpacing * 2),

                          // Language and Category Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _languageController,
                                  label: 'Language',
                                  hint: 'e.g., en',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: _categoryController,
                                  label: 'Category',
                                  hint: 'e.g., Fiction',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.fieldSpacing * 2),

                          // Cover URL
                          _buildTextField(
                            controller: _coverUrlController,
                            label: 'Cover Image URL',
                            hint: 'https://...',
                          ),

                          const SizedBox(height: AppSpacing.fieldSpacing * 2),

                          // Copies Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _totalCopiesController,
                                  label: 'Total Copies',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true)
                                      return 'Required';
                                    if (int.tryParse(value!) == null)
                                      return 'Must be a number';
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: _availableCopiesController,
                                  label: 'Available Copies',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true)
                                      return 'Required';
                                    if (int.tryParse(value!) == null)
                                      return 'Must be a number';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.formSpacing),

                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.destructive.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(
                            color: AppColors.destructive.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.destructive,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: AppTypography.error.copyWith(
                                  color: AppColors.destructive,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: AppSpacing.formSpacing),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _clearForm,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(
                                double.infinity,
                                AppSpacing.buttonHeight,
                              ),
                              side: BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.button,
                                ),
                              ),
                            ),
                            child: Text(
                              'Clear',
                              style: AppTypography.button.copyWith(
                                color: AppColors.foreground,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _createBook,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.primaryForeground,
                              minimumSize: const Size(
                                double.infinity,
                                AppSpacing.buttonHeight,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.button,
                                ),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Create Book',
                                    style: AppTypography.button,
                                  ),
                          ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.border),
        ),
        filled: true,
        fillColor: AppColors.input,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }
}
