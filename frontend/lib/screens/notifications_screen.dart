import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example notifications, replace with actual fetched notifications
    final notifications = [
      'Your book "Flutter in Action" is due tomorrow.',
      'Your reservation for "Clean Code" is now available.',
      'Your book "Data Science Handbook" is overdue.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'No new notifications',
                style: TextStyle(color: AppColors.foreground),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      notification,
                      style: TextStyle(color: AppColors.foreground),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
