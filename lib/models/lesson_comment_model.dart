class LessonCommentModel {
  final int? id;
  final int lessonId;
  final int? senderTeacherId;
  final int? senderStudentId;
  final String message;
  final DateTime timestamp;

  LessonCommentModel({
    this.id,
    required this.lessonId,
    this.senderTeacherId,
    this.senderStudentId,
    required this.message,
    required this.timestamp,
  });

  factory LessonCommentModel.fromJson(Map<String, dynamic> json) {
    return LessonCommentModel(
      id: json['id'] as int,
      lessonId: json['lesson_id'] as int,
      senderTeacherId:
          json['sender_teacher_id'] != null
              ? json['sender_teacher_id'] as int
              : null,
      senderStudentId:
          json['sender_student_id'] != null
              ? json['sender_student_id'] as int
              : null,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'lesson_id': lessonId,
      'sender_teacher_id': senderTeacherId,
      'sender_student_id': senderStudentId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
