import 'book_model.dart';

class Loan {
  final int loanId;
  final BookModel book;
  final int userId;
  final DateTime borrowedAt;
  final DateTime dueAt;
  final DateTime? returnedAt;
  final String status;
  final String notes;

  Loan({
    required this.loanId,
    required this.book,
    required this.userId,
    required this.borrowedAt,
    required this.dueAt,
    this.returnedAt,
    required this.status,
    required this.notes,
  });

  bool get isOverdue => status == 'active' && DateTime.now().isAfter(dueAt);

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      loanId: json['loan_id'],
      book: BookModel.fromJson(json['book']),
      userId: json['user_id'],
      borrowedAt: DateTime.parse(json['borrowed_at']),
      dueAt: DateTime.parse(json['due_at']),
      returnedAt: json['returned_at'] != null ? DateTime.parse(json['returned_at']) : null,
      status: json['status'],
      notes: json['notes'] ?? '',
    );
  }
}
