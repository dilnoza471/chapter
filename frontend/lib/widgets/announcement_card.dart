import 'package:flutter/material.dart';
import '../models/announcement.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementCard({Key? key, required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(announcement.title, style: textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(announcement.content, style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              announcement.createdAt.toLocal().toString(),
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
