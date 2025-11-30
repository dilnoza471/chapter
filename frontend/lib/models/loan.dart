import 'book_model.dart';

class Loan {
  final int loanId;
  final BookModel book;
  final int userId;
  final int studentId; // Changed to int to match DB
  final DateTime borrowedAt;
  final DateTime dueAt;
  final DateTime? returnedAt;
  final String status;
  final String notes;

  Loan({
    required this.loanId,
    required this.book,
    required this.userId,
    required this.studentId,
    required this.borrowedAt,
    required this.dueAt,
    this.returnedAt,
    required this.status,
    required this.notes,
  });

  bool get isOverdue => status == 'active' && DateTime.now().isAfter(dueAt);

  factory Loan.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Loan(
      loanId: _toInt(json['loan_id']) ?? 0,
      book: BookModel.fromJson(json['book'] as Map<String, dynamic>),
      userId: _toInt(json['user_id']) ?? 0,
      studentId: _toInt(json['student_id']) ?? 0,
      borrowedAt: DateTime.parse(json['borrowed_at'] as String),
      dueAt: DateTime.parse(json['due_at'] as String),
      returnedAt: json['returned_at'] != null 
          ? DateTime.parse(json['returned_at'] as String) 
          : null,
      status: json['status'] as String? ?? 'active',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loan_id': loanId,
      'book': book.toJson(),
      'user_id': userId,
      'student_id': studentId,
      'borrowed_at': borrowedAt.toIso8601String(),
      'due_at': dueAt.toIso8601String(),
      'returned_at': returnedAt?.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}