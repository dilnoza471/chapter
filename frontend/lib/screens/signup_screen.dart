import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  final Function(String) onSignUpSuccess;
  const SignUpScreen({super.key, required this.onSignUpSuccess});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _studentId = '';
  String _role = 'student';

  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
        _message = null;
        _isError = false;
      });

      try {
        final result = await _authService.register(
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
          password: _password,
          role: _role,
          studentId: _role == 'student' ? _studentId : null,
        );

        setState(() {
          _message = result;
          _isError = false;
        });

        widget.onSignUpSuccess(_role);
      } catch (e) {
        setState(() {
          _message = e.toString().replaceFirst('Exception: ', '');
          _isError = true;
        });
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _inputStyle(String label, {bool hasError = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF2E4A4D).withOpacity(0.7),
      ),
      filled: true,
      fillColor: const Color(0xFFF5FAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: hasError ? const Color(0xFFE84855) : const Color(0xFFD9E8E8),
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: hasError ? const Color(0xFFE84855) : const Color(0xFFD9E8E8),
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: hasError ? const Color(0xFFE84855) : const Color(0xFF2C8C99),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE84855), width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE84855), width: 2),
      ),
      errorStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFFE84855),
        height: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Account",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2C8C99),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5FAFA),
              Color(0xFFE6F0F0),
              Color(0xFFF5FAFA),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2C8C99).withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon Container
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2C8C99), Color(0xFF4DBFD1)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2C8C99).withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2C8C99), Color(0xFF4DBFD1)],
                      ).createShader(bounds),
                      child: const Text(
                        "Join LMS",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Create your account to get started",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2E4A4D).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // First and Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF2E4A4D),
                            ),
                            decoration: _inputStyle("First Name"),
                            validator: (v) => v!.isEmpty ? "Enter first name" : null,
                            onSaved: (v) => _firstName = v!.trim(),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF2E4A4D),
                            ),
                            decoration: _inputStyle("Last Name"),
                            validator: (v) => v!.isEmpty ? "Enter last name" : null,
                            onSaved: (v) => _lastName = v!.trim(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Email
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2E4A4D),
                      ),
                      decoration: _inputStyle("Email"),
                      validator: (v) =>
                          v!.isEmpty || !v.contains('@') ? "Enter a valid email" : null,
                      onSaved: (v) => _email = v!.trim(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    // Password
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2E4A4D),
                      ),
                      obscureText: true,
                      decoration: _inputStyle("Password"),
                      validator: (v) =>
                          v!.length < 6 ? "Password must be at least 6 characters" : null,
                      onSaved: (v) => _password = v!,
                    ),
                    const SizedBox(height: 24),
                    // Role Dropdown
                    DropdownButtonFormField<String>(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2E4A4D),
                      ),
                      value: _role,
                      decoration: _inputStyle("Registering as"),
                      dropdownColor: const Color(0xFFF5FAFA),
                      items: const [
                        DropdownMenuItem(
                          value: "student",
                          child: Text("Student"),
                        ),
                        DropdownMenuItem(
                          value: "librarian",
                          child: Text("Librarian"),
                        ),
                      ],
                      onChanged: (v) => setState(() => _role = v!),
                    ),
                    const SizedBox(height: 24),
                    // Student ID (conditional)
                    if (_role == "student")
                      TextFormField(
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF2E4A4D),
                        ),
                        decoration: _inputStyle("Student ID"),
                        validator: (v) => v!.isEmpty ? "Student ID required" : null,
                        onSaved: (v) => _studentId = v!.trim(),
                      ),
                    if (_role == "student") const SizedBox(height: 24),
                    // Message
                    if (_message != null)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _isError
                              ? const Color(0xFFE84855).withOpacity(0.1)
                              : const Color(0xFF2C8C99).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _message!,
                          style: TextStyle(
                            color: _isError ? const Color(0xFFE84855) : const Color(0xFF2C8C99),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (_message != null) const SizedBox(height: 24),
                    // Submit Button
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2C8C99), Color(0xFF4DBFD1)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2C8C99).withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Login Link
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Already have an account? Log In",
                        style: TextStyle(
                          color: Color(0xFF2C8C99),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}