class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final int? studentId;
  final DateTime? createdAt;

  String get fullName => '$firstName $lastName';

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.studentId,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      // Handle both camelCase and lowercase from backend
      firstName: json['firstname'] as String? ?? json['firstName'] as String? ?? '',
      lastName: json['lastname'] as String? ?? json['lastName'] as String? ?? '',
      email: json['email'] as String,
      role: json['role'] as String,
      studentId: json['student_id'] as int?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'role': role,
      'student_id': studentId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}