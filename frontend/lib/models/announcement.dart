
class Announcement {
final int id;
final String title;
final String content;
final DateTime createdAt;


Announcement({
required this.id,
required this.title,
required this.content,
required this.createdAt,
});


factory Announcement.fromJson(Map<String, dynamic> json) {
return Announcement(
id: json['id'] as int,
title: json['title'] as String,
content: json['content'] as String,
createdAt: DateTime.parse(json['created_at'] as String),
);
}


Map<String, dynamic> toJson() => {
'id': id,
'title': title,
'content': content,
'created_at': createdAt.toIso8601String(),
};
}