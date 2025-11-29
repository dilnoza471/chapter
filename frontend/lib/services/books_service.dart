// lib/services/books_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BooksService {
  final String baseUrl;
  BooksService({required this.baseUrl});

  Future<BookModel> getBookById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/books/$id'));

    if (response.statusCode == 200) {
      return BookModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load book');
    }
  }
}
