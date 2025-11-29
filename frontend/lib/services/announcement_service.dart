import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/announcement.dart';


class AnnouncementService {
final String baseUrl;
AnnouncementService({required this.baseUrl});


Future<List<Announcement>> fetchAnnouncements() async {
final url = Uri.parse('\$baseUrl/announcements');
final res = await http.get(url);
if (res.statusCode == 200) {
final data = json.decode(res.body) as List<dynamic>;
return data.map((e) => Announcement.fromJson(e as Map<String, dynamic>)).toList();
}
throw Exception('Failed to load announcements');
}


Future<Announcement> postAnnouncement(Map<String, dynamic> body, String authToken) async {
final url = Uri.parse('\$baseUrl/announcements');
final res = await http.post(url, headers: {
'Content-Type': 'application/json',
'Authorization': 'Bearer \$authToken'
}, body: json.encode(body));
if (res.statusCode == 201) {
return Announcement.fromJson(json.decode(res.body) as Map<String, dynamic>);
}
throw Exception('Failed to post announcement');
}
}

