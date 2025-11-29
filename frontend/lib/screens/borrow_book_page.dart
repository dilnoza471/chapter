import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BorrowBookPage extends StatefulWidget {
  const BorrowBookPage({super.key});

  @override
  State<BorrowBookPage> createState() => _BorrowBookPageState();
}

class _BorrowBookPageState extends State<BorrowBookPage> {
  bool isSubmitting = false;
  String? errorMessage;
  final baseUrl = "https://chapter-djfj.onrender.com";

  final TextEditingController bookIdController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  Future<void> submitBorrowRequest() async {
    final bookId = bookIdController.text.trim();
    final studentId = studentIdController.text.trim();

    if (bookId.isEmpty || studentId.isEmpty) {
      setState(() {
        errorMessage = "Please enter both Book ID and Student ID.";
      });
      return;
    }

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/borrow'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'book_id': bookId, 'student_id': studentId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book borrowed successfully!'),
              backgroundColor: Color(0xFF43A047),
            ),
          );
        }
      } else {
        setState(() {
          errorMessage = 'Failed to borrow book (${response.statusCode})';
          isSubmitting = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        title: const Text('Borrow Book', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Book ID Input
            TextField(
              controller: bookIdController,
              decoration: InputDecoration(
                labelText: "Book ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Student ID Input
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(
                labelText: "Student ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Error message
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            // Submit Button
            ElevatedButton(
              onPressed: isSubmitting ? null : submitBorrowRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Confirm Borrow',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
