class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName; 
  final String role;
  final String? studentId;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.studentId,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstname'] as String? ?? '', 
      lastName: json['lastname'] as String? ?? '',  
      role: json['role'] as String? ?? 'student',
      studentId: json['student_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,   
      'role': role,
      'student_id': studentId,
    };
  }
}