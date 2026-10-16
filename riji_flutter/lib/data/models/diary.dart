class Diary {
  final String serverId;
  final String title;
  final String content;
  final String mood;
  final DateTime createdAt;
  final DateTime updatedAt;

  Diary({
    required this.serverId,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      serverId: json['serverId'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      mood: json['mood'] as String? ?? 'calm',
      createdAt: _parseInstant(json['createdAt']),
      updatedAt: _parseInstant(json['updatedAt']),
    );
  }

  static DateTime _parseInstant(dynamic value) {
    if (value is String) return DateTime.parse(value);
    if (value is Map) {
      final seconds = (value['seconds'] as num?)?.toInt() ?? 0;
      final nanos = (value['nanos'] as num?)?.toInt() ?? 0;
      return DateTime.fromMicrosecondsSinceEpoch(seconds * Duration.microsecondsPerSecond + nanos ~/ 1000, isUtc: true);
    }
    throw const FormatException('Invalid diary timestamp');
  }
}

class DiaryRequest {
  final String title;
  final String content;
  final String mood;

  const DiaryRequest({required this.title, required this.content, required this.mood});

  Map<String, dynamic> toJson() => {'title': title, 'content': content, 'mood': mood};
}
