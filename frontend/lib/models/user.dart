class User {
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final int? studentId;

  User({
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    this.studentId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      // student_id may be an int or a string — normalize to int?
      studentId: json['student_id'] is int
          ? json['student_id'] as int
          : (json['student_id'] is String
                ? int.tryParse(json['student_id'])
                : null),
    );
  }
}
