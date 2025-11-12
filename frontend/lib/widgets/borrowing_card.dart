import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/borrowing.dart';
class BorrowingCard extends StatelessWidget{
  final Borrowing borrowing;
  const BorrowingCard({
    Key? key,
    required this.borrowing
  }):super(key: key);

  @override
  Widget build(BuildContext context){
    final isOverdue=borrowing.isOverdue;
    final daysUntilDue=borrowing.daysUntilDue;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    borrowing.book.coverUrl,
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace){
                      return Container(
                        width: 60,
                        height: 90,
                        color: Colors.grey[300],
                        child: Icon(Icons.book, color: Colors.grey[600]),
                      );
                    }
                  )
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        borrowing.book.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        borrowing.book.author,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),

                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                          SizedBox(width:4),
                          Text(
                            'Borrowed: ${DateFormat('MMM dd').format(borrowing.borrowDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ]
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isOverdue
                          ? Colors.red[100]
                          : daysUntilDue<=3
                            ? Colors.orange[100]
                            : Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        
                  
                        ),
                        child: Text(
                          isOverdue
                          ? 'Overdue (${daysUntilDue.abs()} days)'
                          : daysUntilDue==0
                          ? 'DUE TODAY'
                          : 'Due in $daysUntilDue days',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isOverdue
                            ? Colors.red[900]
                            : daysUntilDue<=3
                            ? Colors.orange[900]
                            : Colors.green[900],
                          )
                        ),
                      ),
                    ]
                  )
                ),
              ]
            ),
            SizedBox(height:4),
            Row(
              children:[
                Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  'Return at: Main Library Desk',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  )
                )
              ]
            )
          ],
        ) 
      ),
    );
  }

}