import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService{
  static final NotificationService _instance=NotificationService._internal();
  factory NotificationService()=> _instance();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications=FlutterLocalNotificationsPlugin();

  Future<void> initialize() async{
    const androidSettings=AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings=DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings=InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notifications.initialize(settings);
  }
  Future <void> scheduleBookDueReminder({
    required String bookTitle,
    required DateTime dueDate,
    required int notificationId,
  }) async{
    final scheduledDate=dueDate.subtract(Duration(days: 1));

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
  Future<void> notifyBookAvailable({
    required String bookTitle,
    required int notificationId,
    required int queuePosition,
  }) async{
    await _notifications.show(
      notificationId,
      'Book Available!',
      '$bookTitle is now available for pickup. You\'re in position $queuePosition. First come, first serve!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'book_availability',
          'Book Availability',
          channelDescription: 'Notifications when reserved books become available',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
  Future <void> cancelNotification(int id) async{
    await _notifications.cancel(id);
  }
  Future <void> showImmediateNotification({
    required String title,
    required String body,
  }) async{
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
}