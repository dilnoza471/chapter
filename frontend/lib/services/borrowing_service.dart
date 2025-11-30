import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/loan.dart';

class BorrowingService {
  final String baseUrl;

  BorrowingService({required this.baseUrl});

  /// Fetch all active loans for a specific student
  Future<List<Loan>> getLoansByStudent(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/$studentId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Loan.fromJson(json['result'])).toList();
    } else {
      throw Exception('Failed to load loans');
    }
  }
}
