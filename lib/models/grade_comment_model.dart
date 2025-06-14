class GradeComment {
  final int id;
  final int? gradeId;
  final int? senderTeacherId;
  final int? senderStudentId;
  final String message;
  final DateTime? timestamp;

  GradeComment({
    required this.id,
    this.gradeId,
    this.senderTeacherId,
    this.senderStudentId,
    required this.message,
    this.timestamp,
  });

  factory GradeComment.fromJson(Map<String, dynamic> json) {
    return GradeComment(
      id: json['id'] as int,
      gradeId: json['grade_id'] != null ? json['grade_id'] as int : null,
      senderTeacherId:
          json['sender_teacher_id'] != null
              ? json['sender_teacher_id'] as int
              : null,
      senderStudentId:
          json['sender_student_id'] != null
              ? json['sender_student_id'] as int
              : null,
      message: json['message'] as String,
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grade_id': gradeId,
      'sender_teacher_id': senderTeacherId,
      'sender_student_id': senderStudentId,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
