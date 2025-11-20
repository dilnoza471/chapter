class User {
  final int id;
  final String email;
  final String name;
  final String role;
  final String? studentId;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.studentId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0, // Assuming ID is returned on a profile fetch
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'student',
      studentId: json['student_id'] as String?,
    );
  }
}