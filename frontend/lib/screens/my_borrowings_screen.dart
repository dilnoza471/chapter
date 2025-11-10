import 'package:flutter/material.dart';
import '../models/borrowing.dart';
import '../data/mock_data.dart';
import '../widgets/borrowing_card.dart';
import '../services/notification_service.dart';
import 'my_reservations_screen.dart';

class MyBorrowingsScreen extends StatefulWidget {
  const MyBorrowingsScreen({Key? key}): super(key: key);

  @override
  State <MyBorrowingsScreen> createState()=> _MyBorrowingsScreenState();
}
class _MyBorrowingsScreenState extends State<MyBorrowingsScreen>{
  List<Borrowing> borrowings=[];
  final notificationService=NotificationService();

  @override
  void initState(){
    super.initState();
    _loadBorrowings();
    _scheduleNotifications();
  }
  void _loadBorrowings(){
    setState((){
      borrowings=MockData.borrowings
      .where((b)=>b.status=='active')
      .toList();
    });
  }
  Future <void> _scheduleNotifications() async{
    for (var borrowing in borrowings){
      if(!borrowing.isOverdue){
        await notificationService.scheduleBookDueReminder(
          bookTitle: borrowing.book.title,
          dueDate: borrowing.dueDate,
          notificationId: borrowing.id.hashCode,
        );
      }
    }
  }
  // void _showSnackBar(String message){
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  @override
  Widget build(BuildContext context){
    final overDueCount=borrowings.where((b)=>b.isOverdue).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Borrowings'),
        actions: [
          if (overDueCount>0)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.warning_amber_rounded),
                    onPressed: () {},
                    color: Colors.red,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$overDueCount',
                        style: TextStyle(
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
          IconButton(
            icon: Icon(Icons.pending_actions),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyReservationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: borrowings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No borrowed books',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Visit the library catalog to borrow books',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
          )
          : RefreshIndicator(
              onRefresh: () async{
                _loadBorrowings();
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: borrowings.length,
                itemBuilder: (context, index) {
                  final borrowing=borrowings[index];
                  return BorrowingCard(
                    borrowing: borrowing,
                  );
                },
              ),
          ),
    );
  }
}