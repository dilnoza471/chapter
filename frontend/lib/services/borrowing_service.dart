import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/loan.dart';
import '../models/book_model.dart';

class BorrowingService {
  final String baseUrl;

  BorrowingService({required this.baseUrl});

  /// Fetch all active loans for a specific student
  Future<List<Loan>> getLoansByStudent(String studentId) async {
    final url = Uri.parse('$baseUrl/loans?student_id=$studentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Loan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load loans');
    }
  }
}
