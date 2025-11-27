import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _baseUrl = 'http://127.0.0.1:5001/auth';
const String _userBaseUrl = 'http://127.0.0.1:5001/users';

class AuthService {
  static const String _tokenKey = 'jwtToken';
  static const String _userRoleKey = 'userRole';

  String? _cachedToken;
  String? _cachedRole;

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }

  Future<String?> getRole() async {
    if (_cachedRole != null) return _cachedRole;
    final prefs = await SharedPreferences.getInstance();
    _cachedRole = prefs.getString(_userRoleKey);
    return _cachedRole;
  }

  Future<void> _saveSession(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userRoleKey, role);
    _cachedToken = token;
    _cachedRole = role;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userRoleKey);
    _cachedToken = null;
    _cachedRole = null;
  }

  Future<String> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': identifier, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      final role = data['role'] as String;
      await _saveSession(token, role);
      return 'Success';
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Not logged in. Token not found.');
    }

    final response = await http.get(
      Uri.parse('$_userBaseUrl/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 403) {
      throw Exception('Access denied. Invalid token.');
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch profile.');
    }
  }

  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    String? studentId,
  }) async {
    final body = {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'password': password,
      'role': role,
    };

    if (role == 'student' && studentId != null && studentId.isNotEmpty) {
      body['student_id'] = studentId;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      final role = data['role'] as String;
      await _saveSession(token, role);
      return 'Registration successful!';
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Registration failed.');
    }
  }

  Future<void> logout() async {
    final token = await getToken();
    if (token == null) return;

    try {
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      print('Logout API call failed, but clearing local session: $e');
    } finally {
      await clearSession();
    }
  }
}