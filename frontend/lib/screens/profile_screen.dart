import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final String userRole;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.userRole,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? _userProfile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final profile = await _authService.fetchUserProfile();
      setState(() {
        _userProfile = User.fromJson(profile);
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile(
    String firstName,
    String lastName,
    int? studentId, // student_id is int
  ) async {
    if (_userProfile == null) return;

    final bool nameChanged =
        firstName.trim() != _userProfile!.firstName.trim() ||
        lastName.trim() != _userProfile!.lastName.trim();
    final bool studentIdChanged = studentId != _userProfile!.studentId;

    if (!nameChanged && !studentIdChanged) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No changes to save')));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saving profile...')));

    try {
      await _authService.updateProfile(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        studentId: studentId,
      );
      await _fetchProfile();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Update failed: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    }
  }

  // Safe initials generator - avoids indexing empty strings
  String _getInitials(User user) {
    final f = user.firstName.trim();
    final l = user.lastName.trim();
    if (f.isNotEmpty && l.isNotEmpty) {
      return '${f.characters.first}${l.characters.first}'.toUpperCase();
    }
    if (f.isNotEmpty) {
      return f.characters.first.toUpperCase();
    }
    return '?';
  }

  void _showEditProfileDialog() {
    if (_userProfile == null) return;

    final firstNameController = TextEditingController(
      text: _userProfile!.firstName,
    );
    final lastNameController = TextEditingController(
      text: _userProfile!.lastName,
    );
    final studentIdController = TextEditingController(
      text: _userProfile!.studentId?.toString() ?? '',
    );

    final isStudent = widget.userRole.toLowerCase() == 'student';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last name'),
              ),
              if (isStudent)
                TextField(
                  controller: studentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Student ID (number)',
                  ),
                  keyboardType: TextInputType.number,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final int? parsedStudentId =
                  isStudent && studentIdController.text.trim().isNotEmpty
                  ? int.tryParse(studentIdController.text.trim())
                  : null;

              Navigator.pop(ctx);
              _updateProfile(
                firstNameController.text.trim(),
                lastNameController.text.trim(),
                parsedStudentId,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _fetchProfile,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : (_userProfile == null)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 72,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No profile data available',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _fetchProfile,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.12),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(_userProfile!),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_userProfile!.firstName} ${_userProfile!.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _userProfile!.email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  _buildInfoCard(
                    icon: Icons.person,
                    label: 'First Name',
                    value: _userProfile!.firstName,
                  ),
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    label: 'Last Name',
                    value: _userProfile!.lastName,
                  ),
                  if (_userProfile!.studentId != null)
                    _buildInfoCard(
                      icon: Icons.badge,
                      label: 'Student ID',
                      value: _userProfile!.studentId!.toString(),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _showEditProfileDialog,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
