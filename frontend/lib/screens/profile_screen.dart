// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
// Assuming you have a User model defined in ../models/user.dart
// import '../models/user.dart'; 

class ProfileScreen extends StatefulWidget {
  final String userRole;
  final VoidCallback onLogout;
  
  const ProfileScreen({super.key, required this.userRole, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await _authService.fetchUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Add a refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchProfile,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.person_pin, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              
              if (_isLoading)
                const CircularProgressIndicator(),
              
              if (_error != null)
                Text(
                  'Error loading profile: $_error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              
              if (_userProfile != null && !_isLoading) ...[
                Text(
                  _userProfile!['name'] ?? 'User Name',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  _userProfile!['email'] ?? 'No Email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  'Role: ${(_userProfile!['role'] as String).toUpperCase()}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: widget.userRole == 'librarian' ? Colors.green : Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (_userProfile!['role'] == 'student')
                  Text(
                    'Books Borrowed: ${_userProfile!['borrowed_books_count'] ?? 0}',
                    style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                const SizedBox(height: 40),
                
                // Placeholder for Update Profile button
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement navigation to UpdateProfileScreen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Update Profile feature coming soon!'))
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
                const SizedBox(height: 20),
              ],
              
              // Logout Button is outside the data display block so it's always visible
              ElevatedButton.icon(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}