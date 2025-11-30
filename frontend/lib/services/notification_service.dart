import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/models/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Replace with your backend base URL
  final String _baseUrl = 'https://chapter-djfj.onrender.com/notifications';

  /// ------------------- Local Notifications -------------------
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notifications.initialize(settings);
  }

  Future<void> scheduleBookDueReminder({
    required String bookTitle,
    required DateTime dueDate,
    required int notificationId,
  }) async {
    final scheduledDate = dueDate.subtract(const Duration(days: 1));

    await _notifications.zonedSchedule(
      notificationId,
      'Book Due Soon!',
      '$bookTitle is due tomorrow',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'book_reminders',
          'Book Due Reminders',
          channelDescription: 'Reminders for book due dates',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notifications',
          'Instant Notifications',
          channelDescription: 'Immediate notifications for actions',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// ------------------- Backend Notifications -------------------

  Future<List<NotificationModel>> getNotificationsByStudent(
    String studentId,
  ) async {
    final response = await http.get(Uri.parse('$_baseUrl/$studentId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$notificationId/read'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<void> createNotification(NotificationModel notification) async {
    final response = await http.post(
      Uri.parse('$_baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create notification');
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$notificationId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete notification');
    }
  }
}
