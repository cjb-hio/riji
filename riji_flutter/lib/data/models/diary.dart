class Diary {
  final String? clientId;
  final String? serverId;
  final String title;
  final String content;
  final String mood;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;

  Diary({
    this.clientId,
    this.serverId,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
    required this.updatedAt,
    this.deleted = false,
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      clientId: json['clientId'],
      serverId: json['serverId'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      mood: json['mood'] ?? 'calm',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deleted: json['deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (clientId != null) 'clientId': clientId,
      if (serverId != null) 'serverId': serverId,
      'title': title,
      'content': content,
      'mood': mood,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deleted': deleted,
    };
  }

  Diary copyWith({
    String? clientId,
    String? serverId,
    String? title,
    String? content,
    String? mood,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return Diary(
      clientId: clientId ?? this.clientId,
      serverId: serverId ?? this.serverId,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }
}
