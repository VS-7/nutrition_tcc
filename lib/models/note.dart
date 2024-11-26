class Note {
  final int? id;
  final String content;
  final String mood;
  final DateTime date;

  Note({
    this.id,
    required this.content,
    required this.mood,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'mood': mood,
      'date': date.toIso8601String().split('T')[0],
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      content: map['content'] as String,
      mood: map['mood'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  Note copyWith({
    int? id,
    String? content,
    String? mood,
    DateTime? date,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      date: date ?? this.date,
    );
  }
}