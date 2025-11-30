import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../services/borrowing_service.dart';
import '../widgets/borrowing_card.dart';
import '../services/notification_service.dart';

class MyBorrowingsScreen extends StatefulWidget {
  final String studentId;

  const MyBorrowingsScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  State<MyBorrowingsScreen> createState() => _MyBorrowingsScreenState();
}

class _MyBorrowingsScreenState extends State<MyBorrowingsScreen> {
  List<Loan> borrowings = [];
  final notificationService = NotificationService();
  late BorrowingService borrowingService;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    borrowingService = BorrowingService(baseUrl: 'https://chapter-djfj.onrender.com');
    _loadBorrowings();
  }

  Future<void> _loadBorrowings() async {
    setState(() => isLoading = true);
    try {
      final fetchedBorrowings = await borrowingService.getLoansByStudent(widget.studentId);
      setState(() {
        borrowings = fetchedBorrowings.where((b) => b.status == 'active').toList();
      });
      _scheduleNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load borrowings: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _scheduleNotifications() async {
    for (var borrowing in borrowings) {
      if (!borrowing.isOverdue) {
        await notificationService.scheduleBookDueReminder(
          bookTitle: borrowing.book.title,
          dueDate: borrowing.dueAt,
          notificationId: borrowing.loanId.hashCode,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final overDueCount = borrowings.where((b) => b.isOverdue).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Borrowings'),
        actions: [
          if (overDueCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.warning_amber_rounded),
                    onPressed: () {},
                    color: Colors.red,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$overDueCount',
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
          : borrowings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.library_books_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No borrowed books',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Visit the library catalog to borrow books',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadBorrowings,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: borrowings.length,
                    itemBuilder: (context, index) {
                      final borrowing = borrowings[index];
                      return BorrowingCard(
                        borrowing: borrowing,
                      );
                    },
                  ),
                ),
    );
  }
}
