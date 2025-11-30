import 'package:flutter/material.dart';
import '../models/reservation.dart';


class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onCancel;

  const ReservationCard({
    Key? key,
    required this.reservation,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAvailable = reservation.status == 'available';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reservation.book.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Author: ${reservation.book.author}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Reserved on: ${reservation.reservationDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Status: ${reservation.status}',
              style: TextStyle(
                fontSize: 12,
                color: isAvailable ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (reservation.queuePosition > 1)
              Text(
                'Queue position: ${reservation.queuePosition}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onCancel,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
