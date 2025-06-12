class Lesson {
  final int id;
  final int subjectId;
  final int teacherId;
  final DateTime date;
  final String? topic;

  Lesson({
    required this.id,
    required this.subjectId,
    required this.teacherId,
    required this.date,
    this.topic,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      subjectId: json['subject_id'] as int,
      teacherId: json['teacher_id'] as int,
      date: DateTime.parse(json['date']),
      topic: json['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'teacher_id': teacherId,
      'date': date.toIso8601String(),
      'topic': topic,
    };
  }
}
