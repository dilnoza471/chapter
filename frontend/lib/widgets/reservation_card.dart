import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reservation.dart';
class ReservationCard extends StatelessWidget{
  final Reservation reservation;
  final VoidCallback onCancel;
  const ReservationCard({
    Key? key,
    required this.reservation,
    required this.onCancel,
  }): super(key: key);
  @override
  Widget build(BuildContext context) {
    final isAvailable= reservation.status=='available';
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    reservation.book.coverUrl,
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
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.book.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height:4),
                      Text(
                        reservation.book.author,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 400),
                          Text(
                            'Reserved: ${DateFormat('MMM dd').format(reservation.reservationDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                          ? Colors.green[100]
                          : Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isAvailable
                          ? 'READY FOR PICKUP'
                          : 'Queue Position: ${reservation.queuePosition}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isAvailable
                            ? Colors.green[900]
                            : Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onCancel,
                icon: Icon(Icons.close, size: 18),
                label: Text('Cancel Reservation'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            if(isAvailable)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.green[700]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Book is ready! Pick up at Main Library Desk within 48 hours.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'You will be notified when book becomes available',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    
  }
}