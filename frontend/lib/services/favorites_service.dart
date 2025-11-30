import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  final String baseUrl =
      'https://chapter-djfj.onrender.com/api/favorites'; // Change to your backend URL
  final supabase = Supabase.instance.client;

  Future<String> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token =
          prefs.getString('jwtToken') ??
          ''; // Use 'jwtToken' instead of 'auth_token'
      print('🔑 Token from SharedPreferences: $token');
      print('🔑 Token length: ${token.length}');
      return token;
    } catch (e) {
      print('❌ Error getting token: $e');
      return '';
    }
  }

  // Add book to favorites
  Future<void> addFavorite(String bookIsbn) async {
    try {
      final token = await _getAuthToken();

      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'bookIsbn': bookIsbn}),
      );

      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to add favorite: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Remove book from favorites
  Future<void> removeFavorite(String bookIsbn) async {
    try {
      final token = await _getAuthToken();
      final response = await http.post(
        Uri.parse('$baseUrl/remove'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'bookIsbn': bookIsbn}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove favorite: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get all user favorites
  Future<List<dynamic>> getUserFavorites() async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/my-favorites'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch favorites: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Check if a book is favorited
  Future<bool> isFavorited(String bookIsbn) async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/check/$bookIsbn'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorited'] ?? false;
      } else {
        throw Exception('Failed to check favorite: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
