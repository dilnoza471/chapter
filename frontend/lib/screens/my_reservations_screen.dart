import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../data/mock_data.dart';
import '../widgets/reservation_card.dart';
import '../services/notification_service.dart';

class MyReservationsScreen extends StatefulWidget {
    const MyReservationsScreen({Key? key}) : super(key: key);

    @override
    State <MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
    List <Reservation> reservations=[];
    final notificationService=NotificationService();

    @override
    void initState(){
        super.initState();
        _loadReservations();
    }

    void _loadReservations(){
        setState(() {
            reservations=MockData.reservations
            .where((r)=> r.status!='expired')
            .toList();
        });
    }

    Future <void> _cancelReservation(Reservation reservation) async{
        final confirmed=await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                title: Text('Cancel Reservation'),
                content: Text(
                    'Are you sure you want to cancel your reservation for "${reservation.book.title}"?',
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('No'),
                    ),
                    ElevatedButton(
                        onPressed: ()=> Navigator.pop(context, true),
                        child: Text('Yes, Cancel'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                        ),
                    ),
                ],
            ),
        );
        if(confirmed==true){
            setState(() {
                reservations.removeWhere((r)=>r.id==reservation.id);
            });

            await notificationService.showImmediateNotification(
                title: 'Reservation Cancelled',
                body: 'Your reservation for ${reservation.book.title} has  been cancelled',
            );

            _showSnackBar('Reservation Cancelled');
            
        }
    }
    void _showSnackBar(String message){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
        );
    } 

    @override
    Widget build(BuildContext context){
        final availableCount=reservations.where((r)=> r.status=='available').length;

        return Scaffold(
            appBar: AppBar(
                title: Text('My Reservations'),
                actions: [
                    if (availableCount>0)
                      Padding(
                        padding: EdgeInsets.only(right:8),
                        child: Stack(
                            children: [
                                IconButton(
                                    icon: Icon(Icons.notifications_active),
                                    onPressed: () {},
                                    color: Colors.green,
                                ),
                                Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                        ),
                                        constraints: BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                        ),
                                        child: Text(
                                            '$availableCount',
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
                ],
            ),
            body: reservations.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Icon(
                            Icons.bookmark_border,
                            size: 80,
                            color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                            'No active reservations',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                            ),
                        ),
                        SizedBox(height: 8),
                        Text(
                            'Reserve unavailable books from the catalog',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                            ),
                        ),
                    ],
                ),
            )
            :RefreshIndicator(
                onRefresh: () async{
                    _loadReservations();
                },
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: reservations.length,
                    itemBuilder: (context, index){
                        final reservation= reservations[index];
                        return ReservationCard(
                            reservation: reservation,
                            onCancel: () => _cancelReservation(reservation),
                        );
                    },
                ),
            ),
        );
    }
}