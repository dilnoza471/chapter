import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import '../models/loan.dart';
import '../services/borrowing_service.dart';
import '../widgets/borrowing_card.dart';
import '../services/notification_service.dart';
import '../screens/MyReservationsScreen.dart';
import '../theme/app_colors.dart';

class MyBorrowingsScreen extends StatefulWidget {
  const MyBorrowingsScreen({super.key});

  @override
  State<MyBorrowingsScreen> createState() => _MyBorrowingsScreenState();
}

class _MyBorrowingsScreenState extends State<MyBorrowingsScreen> {
  List<Loan> borrowings = [];
  String studentId = '';
  final notificationService = NotificationService();
  late BorrowingService borrowingService;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    borrowingService = BorrowingService(
      //baseUrl: 'http://localhost:5001/api/borrowings',
      baseUrl: 'https://chapter-djfj.onrender.com/api/borrowings',
    );
    _loadBorrowings();
  }

  Future<void> _loadBorrowings() async {
    setState(() => isLoading = true);
    try {
      studentId = await AuthService().getStudentId();
      final fetchedBorrowings = await borrowingService.getLoansByStudent(
        studentId,
      );
      setState(() {
        borrowings = fetchedBorrowings
            .where((b) => b.status == 'active')
            .toList();
      });
      _scheduleNotifications();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load borrowings: $e')));
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
        backgroundColor: AppColors.primary,
        actions: [
          if (overDueCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.warning_amber_rounded),
                    onPressed: () {},
                    color: AppColors.destructive,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.destructive,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$overDueCount',
                        style: TextStyle(
                          color: AppColors.primaryForeground,
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
            IconButton(
      icon: const Icon(Icons.bookmark),
      tooltip: 'My Reservations',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyReservationsScreen(),
          ),
        );
      },
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
                  return BorrowingCard(borrowing: borrowing);
                },
              ),
            ),
    );
  }
}
