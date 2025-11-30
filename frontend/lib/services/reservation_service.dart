import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation.dart';

class ReservationService {
  final String baseUrl;

  ReservationService({required this.baseUrl});

  /// Fetch all reservations for a specific student
  Future<List<Reservation>> getReservationsByStudent(String studentId) async {
    final url = Uri.parse('$baseUrl/reservations?student_id=$studentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Reservation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  /// Cancel a specific reservation by ID
  Future<void> cancelReservation(String reservationId) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel reservation');
    }
  }
}

