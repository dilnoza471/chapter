class User {
  final String firstName;
  final String lastName;
  final String email;
  final int? studentId; // changed to int?

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.studentId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // normalise student_id to int when possible
    int? sid;
    final raw = json['student_id'];
    if (raw is int)
      sid = raw;
    else if (raw is String)
      sid = int.tryParse(raw);
    return User(
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      email: json['email'] ?? '',
      studentId: sid,
    );
  }
}
