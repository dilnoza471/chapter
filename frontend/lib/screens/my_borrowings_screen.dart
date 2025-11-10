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
}