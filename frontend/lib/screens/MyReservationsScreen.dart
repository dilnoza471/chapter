import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';
import '../widgets/reservation_card.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List<Reservation> reservations = [];
  final notificationService = NotificationService();
  late ReservationService reservationService;
  bool isLoading = true;
  String studentId = AuthService().currentStudentId as String;
  @override
  void initState() {
    super.initState();
    // Initialize the service with your backend URL
    reservationService = ReservationService();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() => isLoading = true);
    try {
      final fetchedReservations = await reservationService
          .getReservationsByStudent(studentId);
      setState(() {
        reservations = fetchedReservations;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load reservations: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _cancelReservation(Reservation reservation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Reservation'),
        content: Text(
          'Are you sure you want to cancel your reservation for "${reservation.book.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await reservationService.cancelReservation(reservation.id);
        setState(() {
          reservations.removeWhere((r) => r.id == reservation.id);
        });

        await notificationService.showImmediateNotification(
          title: 'Reservation Cancelled',
          body:
              'Your reservation for ${reservation.book.title} has been cancelled',
        );

        _showSnackBar('Reservation Cancelled');
      } catch (e) {
        _showSnackBar('Failed to cancel reservation: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final availableCount = reservations
        .where((r) => r.status == 'available')
        .length;

    return Scaffold(
      // Only updated AppBar and colors
      appBar: AppBar(
        title: const Text('My Reservations'),
        backgroundColor: AppColors.primary,
        actions: [
          if (availableCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_active),
                    onPressed: () {},
                    color: Colors.green,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$availableCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reservations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pending_actions_rounded,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No active reservations',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Reserve unavailable books from the catalog',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadReservations,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return ReservationCard(
                    reservation: reservation,
                    onCancel: () => _cancelReservation(reservation),
                  );
                },
              ),
            ),
    );
  }
}
