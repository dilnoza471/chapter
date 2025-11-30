import 'book_model.dart';

class Reservation {
  final String id;
  final BookModel book;
  final DateTime reservationDate;
  final String status;
  final int queuePosition;

  Reservation({
    required this.id,
    required this.book,
    required this.reservationDate,
    required this.status,
    this.queuePosition = 1,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      book: BookModel.fromJson(json['book']),
      reservationDate: DateTime.parse(json['reservationDate']),
      status: json['status'],
      queuePosition: json['queuePosition'] ?? 1,
    );
  }
}
