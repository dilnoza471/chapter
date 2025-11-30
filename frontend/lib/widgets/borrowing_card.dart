import 'package:flutter/material.dart';
import '../models/loan.dart';

class BorrowingCard extends StatelessWidget {
  final Loan borrowing;

  const BorrowingCard({Key? key, required this.borrowing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverdue = borrowing.isOverdue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              borrowing.book.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Author: ${borrowing.book.author}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Borrowed: ${borrowing.borrowedAt.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Due: ${borrowing.dueAt.toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 12,
                color: isOverdue ? Colors.red : Colors.grey[700],
                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (borrowing.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Notes: ${borrowing.notes}',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
