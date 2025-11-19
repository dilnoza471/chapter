import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user.dart'; // Ensure this model import is correct

// IMPORTANT: Replace this with your actual backend URL
const String _baseUrl = 'http://127.0.0.1:5001/auth';

const String _userBaseUrl = 'http://127.0.0.1:5001/users';

// 10.0.2.2 is the special address to access the host machine's localhost from an Android emulator.
// Use 'http://localhost:5000/auth' for web or iOS simulator.

class AuthService {
  // Static keys for shared preferences
  static const String _tokenKey = 'jwtToken';
  static const String _userRoleKey = 'userRole';

  String? _cachedToken;
  String? _cachedRole;

  // --- Session Management ---

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
  
  // --- API Calls ---

  // Login: POST /auth/login
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      // 🚨 FIX HERE: Changed 'email' to 'identifier'
      body: jsonEncode({'identifier': email, 'password': password}), 
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

    // This calls the protected route GET /users/me
    final response = await http.get(
      Uri.parse('$_userBaseUrl/me'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Return the JSON response map
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 403) {
      throw Exception('Access denied. Invalid token.');
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch profile.');
    }
  }

  // Registration: POST /auth/register
  Future<String> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? studentId,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
    
    // Only include student_id if the user is a student
    if (role == 'student' && studentId != null && studentId.isNotEmpty) {
      body['student_id'] = studentId;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return 'Registration successful! You can now log in.';
    } else {
      final errorData = jsonDecode(response.body);
      // Backend error messages like 'User with this email already exists.'
      throw Exception(errorData['message'] ?? 'Registration failed.');
    }
  }

  // Logout: POST /auth/logout
  Future<void> logout() async {
    final token = await getToken();
    if (token == null) return;

    // Call the backend to invalidate the session/token (if implemented)
    // NOTE: If your backend's /auth/logout is not protected, you don't need the token here.
    // If it is protected, you must include the Authorization header.
    try {
        await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
    } catch (e) {
      // Ignore network errors during logout, client-side session clearing is paramount
      print('Logout API call failed, but clearing local session: $e');
    } finally {
      await clearSession();
    }
  }
}