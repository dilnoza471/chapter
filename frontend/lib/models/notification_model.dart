class NotificationModel {
  final int? id;
  final String studentId;
  final String type;
  final String title;
  final String body;
  final String? relatedId;
  bool isRead; // <-- remove final
  final DateTime? createdAt;
  final DateTime? scheduledFor;

  NotificationModel({
    this.id,
    required this.studentId,
    required this.type,
    required this.title,
    required this.body,
    this.relatedId,
    this.isRead = false, // default false
    this.createdAt,
    this.scheduledFor,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'],
        studentId: json['studentId'],
        type: json['type'],
        title: json['title'],
        body: json['body'],
        relatedId: json['relatedId'],
        isRead: json['isRead'] ?? false,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        scheduledFor: json['scheduledFor'] != null ? DateTime.parse(json['scheduledFor']) : null,
      );

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'type': type,
        'title': title,
        'body': body,
        'relatedId': relatedId,
        'isRead': isRead,
        'scheduledFor': scheduledFor?.toIso8601String(),
      };
}

