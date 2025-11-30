import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

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

class ReservationService {
  final String baseUrl;

  ReservationService({required this.baseUrl});

  /// Fetch reservations for a specific student
  Future<List<Reservation>> getReservationsByStudent(String studentId) async {
    final url = Uri.parse('$baseUrl/reservations?student_id=$studentId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Reservation.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load reservations: ${response.statusCode}');
    }
  }

  /// Cancel a reservation
  Future<void> cancelReservation(String reservationId) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to cancel reservation: ${response.statusCode}');
    }
  }
}
