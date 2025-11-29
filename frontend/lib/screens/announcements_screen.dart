import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../widgets/announcement_card.dart';
import '../services/announcement_service.dart';

class AnnouncementsScreen extends StatefulWidget {
final AnnouncementService announcementService;
const AnnouncementsScreen({Key? key, required this.announcementService}) : super(key: key);


@override
_AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}


class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
List<Announcement> _announcements = [];
bool _loading = true;


@override
void initState() {
super.initState();
_fetch();
}


Future<void> _fetch() async {
setState(() => _loading = true);
try {
final list = await widget.announcementService.fetchAnnouncements();
setState(() => _announcements = list);
} catch (e) {
// handle
} finally {
setState(() => _loading = false);
}
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text('Announcements')),
body: RefreshIndicator(
onRefresh: _fetch,
child: _loading
? Center(child: CircularProgressIndicator())
: ListView.builder(
itemCount: _announcements.length,
itemBuilder: (context, index) => AnnouncementCard(announcement: _announcements[index]),
),
),
);
}
}

