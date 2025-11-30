import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../theme/app_colors.dart';

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
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reservation.book.title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground),
            ),
            const SizedBox(height: 4),
            Text(
              'Author: ${reservation.book.author}',
              style: TextStyle(fontSize: 14, color: AppColors.foreground),
            ),
            const SizedBox(height: 4),
            Text(
              'Reserved on: ${reservation.reservationDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 12, color: AppColors.foreground.withOpacity(0.7)),
            ),
            Text(
              'Status: ${reservation.status}',
              style: TextStyle(
                fontSize: 12,
                color: isAvailable ? Colors.green : AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (reservation.queuePosition > 1)
              Text(
                'Queue position: ${reservation.queuePosition}',
                style: TextStyle(fontSize: 12, color: AppColors.foreground.withOpacity(0.7)),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.destructive),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

