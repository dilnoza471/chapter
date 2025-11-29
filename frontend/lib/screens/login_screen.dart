import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final Function(String?) onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _identifier = ''; 
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await _authService.login(_identifier, _password); 
        final role = await _authService.getRole();
        widget.onLoginSuccess(role);
      } catch (e) {
        setState(() => _errorMessage = e.toString().replaceFirst("Exception: ", ""));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _input(String label, {bool hasError = false}) {
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
          "Login to LMS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2C8C99),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
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
                            Icons.login,
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
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign in to access your library account",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF2E4A4D).withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Email/Student ID Field
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF2E4A4D),
                          ),
                          decoration: _input("Email or Student ID"),
                          validator: (v) => v!.isEmpty ? "Enter your email or student ID" : null,
                          onChanged: (v) => _identifier = v,
                        ),
                        const SizedBox(height: 24),
                        // Password Field
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF2E4A4D),
                          ),
                          obscureText: true,
                          decoration: _input("Password"),
                          validator: (v) => v!.isEmpty ? "Enter password" : null,
                          onChanged: (v) => _password = v,
                        ),
                        const SizedBox(height: 24),
                        // Error Message
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE84855).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFFE84855),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (_errorMessage != null) const SizedBox(height: 24),
                        // Login Button
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
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Sign Up Link
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          child: const Text(
                            "Don't have an account? Sign Up",
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
          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2C8C99),
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}