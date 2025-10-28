import 'book.dart';
class Reservation{
  final String id;
  final Book book;
  final DateTime reservationDate;
  final String status;
  final int queuePosition;
  Reservation({
    required this.id,
    required this.book,
    required this.reservationDate,
    required this.status,
    this.queuePosition=1,
  });
  Reservation copyWith({
    String? status,
    int? queuePosition,
  }){
    return Reservation(
      id: id,
      book: book,
      reservationDate: reservationDate,
      status: status ?? this.status,
      queuePosition: queuePosition ?? this.queuePosition,
    );
  }
}