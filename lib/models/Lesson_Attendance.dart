class LessonAttendance {
  final int id;
  final int lessonId;
  final int studentId;
  final String status;

  LessonAttendance({
    required this.id,
    required this.lessonId,
    required this.studentId,
    required this.status,
  });

  factory LessonAttendance.fromJson(Map<String, dynamic> json) {
    return LessonAttendance(
      id: json['id'] as int,
      lessonId: json['lesson_id'] as int,
      studentId: json['student_id'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'student_id': studentId,
      'status': status,
    };
  }
}
