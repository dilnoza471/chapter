import 'package:flutter/material.dart';

class AuthService {
  Future<String> register(Map<String, dynamic> registrationData) async {
    print('Registering user with data: $registrationData');
    await Future.delayed(const Duration(milliseconds: 800)); 
    
    if (registrationData['email'] == 'fail@example.com') {
      throw Exception('This email is already registered.');
    }
    return 'Registration Successful!';
  }
}


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

      final Map<String, dynamic> registrationBody = {
        'email': _email,
        'password': _password,
        'firstname': _firstName,
        'lastname': _lastName,
        'role': _role,
      };

      if (_role == 'student') {
        registrationBody['student_id'] = _studentId;
      }
      
      try {
        final result = await _authService.register(registrationBody); 

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
  
  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Join LMS",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: _inputStyle("First Name"),
                            validator: (v) => v!.isEmpty ? "Enter first name" : null,
                            onChanged: (v) => _firstName = v.trim(),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            decoration: _inputStyle("Last Name"),
                            validator: (v) => v!.isEmpty ? "Enter last name" : null,
                            onChanged: (v) => _lastName = v.trim(),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),

                    TextFormField(
                      decoration: _inputStyle("Email"),
                      validator: (v) => v!.isEmpty || !v.contains('@') ? "Enter a valid email" : null,
                      onChanged: (v) => _email = v.trim(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      obscureText: true,
                      decoration: _inputStyle("Password"),
                      validator: (v) => v!.length < 6 ? "Password must be at least 6 characters" : null,
                      onChanged: (v) => _password = v,
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: _inputStyle("Registering as"),
                      items: const [
                        DropdownMenuItem(value: "student", child: Text("Student")),
                        DropdownMenuItem(value: "librarian", child: Text("Librarian")),
                      ],
                      onChanged: (v) => setState(() => _role = v!),
                    ),
                    const SizedBox(height: 20),

                    if (_role == "student")
                      TextFormField(
                        decoration: _inputStyle("Student ID (e.g., S1001)"),
                        validator: (v) =>
                            v!.isEmpty ? "Student ID required" : null,
                        onChanged: (v) => _studentId = v.trim(),
                      ),

                    const SizedBox(height: 20),

                    if (_message != null)
                      Text(
                        _message!,
                        style: TextStyle(
                          color: _isError ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                          : const Text("Create Account", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Already have an account? Log In",
                          style: TextStyle(color: Colors.indigo)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}