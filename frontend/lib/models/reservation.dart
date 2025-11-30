import 'book_model.dart';

class Reservation {
  final int id;
  final int studentId;
  final BookModel book;
  final DateTime reservedAt;
  final DateTime expiresAt;
  final String status;

  Reservation({
    required this.id,
    required this.studentId,
    required this.book,
    required this.reservedAt,
    required this.expiresAt,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      book: BookModel.fromJson(json['book']),
      reservedAt: DateTime.parse(json['reserved_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      status: json['status'],
    );
  }
}
