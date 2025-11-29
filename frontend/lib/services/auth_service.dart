import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _baseUrl = 'https://chapter-djfj.onrender.com/auth';
const String _userBaseUrl = 'https://chapter-djfj.onrender.com/users';

class AuthService {
  static const String _tokenKey = 'jwtToken';
  static const String _userRoleKey = 'userRole';

  String? _cachedToken;
  String? _cachedRole;

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    print(
      '📱 Retrieved token: ${_cachedToken != null ? "Token exists (${_cachedToken!.length} chars)" : "No token"}',
    );
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
    print('✅ Session saved - Role: $role');
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userRoleKey);
    _cachedToken = null;
    _cachedRole = null;
    print('🗑️ Session cleared');
  }

  Future<String> login(String identifier, String password) async {
    print('=== LOGIN REQUEST ===');
    print('Identifier: $identifier');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': identifier, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final role = data['role'] as String;
        await _saveSession(token, role);
        print('✅ Login successful');
        return 'Success';
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ Login failed: ${errorData['message']}');
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    print('=== FETCH PROFILE REQUEST ===');

    final token = await getToken();
    if (token == null) {
      print('❌ No token found');
      throw Exception('Not logged in. Token not found.');
    }

    print('📤 Making request to: $_userBaseUrl/me');
    print(
      'Token (first 30 chars): ${token.substring(0, token.length > 30 ? 30 : token.length)}...',
    );

    try {
      final response = await http.get(
        Uri.parse('$_userBaseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Profile fetched successfully');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Token may be expired');
        await clearSession(); // Clear invalid session
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        print('❌ Forbidden - Invalid token');
        await clearSession(); // Clear invalid session
        throw Exception('Access denied. Please login again.');
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ Error: ${errorData['message']}');
        throw Exception(errorData['message'] ?? 'Failed to fetch profile.');
      }
    } catch (e) {
      print('❌ Profile fetch error: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    // Email field removed from signature
    int? studentId,
  }) async {
    print('=== UPDATE PROFILE REQUEST ===');

    final token = await getToken();
    if (token == null) {
      print('❌ No token found');
      throw Exception('Not logged in. Token not found.');
    }

    final fullName = '$firstName $lastName';

    // Build the request body with only name and student_id
    final body = {'name': fullName};
    // Email field REMOVED from the body logic
    if (studentId != null) {
      body['student_id'] = studentId as String;
    }

    try {
      final response = await http.put(
        Uri.parse('$_userBaseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body), // Only sends name and student_id
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        print('❌ Update failed: ${errorData['message']}');
        throw Exception(errorData['message'] ?? 'Failed to update profile.');
      }
      print('✅ Profile updated successfully');
    } catch (e) {
      print('❌ Profile update error: $e');
      rethrow;
    }
  }

  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    int? studentId,
  }) async {
    print('=== REGISTRATION REQUEST ===');
    print('Email: $email, Role: $role');

    final body = {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'password': password,
      'role': role,
    };

    if (role == 'student' && studentId != null) {
      body['student_id'] = studentId as String;
      print('Student ID: $studentId');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final role = data['role'] as String;
        await _saveSession(token, role);
        print('✅ Registration successful');
        return 'Registration successful!';
      } else if (response.statusCode == 202) {
        print('⚠️ Email confirmation required');
        final data = jsonDecode(response.body);
        throw Exception(
          data['message'] ?? 'Please check your email for confirmation.',
        );
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ Registration failed: ${errorData['message']}');
        throw Exception(errorData['message'] ?? 'Registration failed.');
      }
    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    print('=== LOGOUT REQUEST ===');

    final token = await getToken();
    if (token == null) {
      print('No token to logout with');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('Logout response: ${response.statusCode}');
    } catch (e) {
      print('Logout API call failed (will clear local session anyway): $e');
    } finally {
      await clearSession();
      print('✅ Logout complete');
    }
  }
}
