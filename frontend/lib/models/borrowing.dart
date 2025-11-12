import 'book.dart';
class Borrowing{
  final String id;
  final Book book;
  final DateTime borrowDate;
  final DateTime dueDate;
  final String status;

  Borrowing({
    required this.id,
    required this.book,
    required this.borrowDate,
    required this.dueDate,
    required this.status,
  });
  bool get isOverdue => DateTime.now().isAfter(dueDate) && status=='active';
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;
  Borrowing copyWith({
    String? status,
  }){
    return Borrowing(
      id: id,
      book: book,
      borrowDate: borrowDate,
      dueDate: dueDate,
      status: status ?? this.status,
    );
  }
}