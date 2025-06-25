import 'package:edu_sync/models/student_model.dart';
import 'package:edu_sync/models/grade_model.dart';
import 'package:edu_sync/models/lesson_attendance_model.dart';

class StudentCache {
  static StudentModel? currentStudent;
  static List<GradeModel>? cachedGrades;
  static List<LessonAttendance>? cachedAttendance;

  static void clear() {
    currentStudent = null;
    cachedGrades = null;
    cachedAttendance = null;
  }
}
