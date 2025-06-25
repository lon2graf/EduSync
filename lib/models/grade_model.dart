class GradeModel {
  final int? id;
  final int lessonId;
  final int studentId;
  final int gradeValue;

  GradeModel({
    this.id,
    required this.lessonId,
    required this.studentId,
    required this.gradeValue,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'] as int,
      lessonId: json['lesson_id'] as int,
      studentId: json['student_id'] as int,
      gradeValue: json['grade_value'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'lesson_id': lessonId,
      'student_id': studentId,
      'grade_value': gradeValue,
    };
  }
}
