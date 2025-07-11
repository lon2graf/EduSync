class LessonModel {
  final int? id;
  final int subjectId;
  final int teacherId;
  final DateTime date;
  final String? topic;
  final int groupId;

  LessonModel({
    this.id,
    required this.subjectId,
    required this.teacherId,
    required this.date,
    this.topic,
    required this.groupId,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int,
      subjectId: json['subject_id'] as int,
      teacherId: json['teacher_id'] as int,
      date: DateTime.parse(json['date']),
      topic: json['topic'] as String?,
      groupId: json['group_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subject_id': subjectId,
      'teacher_id': teacherId,
      'date': date.toIso8601String(),
      'topic': topic,
      'group_id': groupId,
    };
  }
}
