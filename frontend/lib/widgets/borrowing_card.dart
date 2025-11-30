import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../theme/app_colors.dart';

class BorrowingCard extends StatelessWidget {
  final Loan borrowing;

  const BorrowingCard({super.key, required this.borrowing});

  @override
  Widget build(BuildContext context) {
    final isOverdue = borrowing.isOverdue;

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              borrowing.book.title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground),
            ),
            const SizedBox(height: 4),
            Text(
              'Author: ${borrowing.book.author}',
              style: TextStyle(fontSize: 14, color: AppColors.foreground),
            ),
            const SizedBox(height: 4),
            Text(
              'Borrowed: ${borrowing.borrowedAt.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 12, color: AppColors.foreground.withOpacity(0.7)),
            ),
            Text(
              'Due: ${borrowing.dueAt.toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 12,
                color: isOverdue ? AppColors.destructive : AppColors.foreground,
                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (borrowing.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Notes: ${borrowing.notes}',
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.foreground.withOpacity(0.7)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
