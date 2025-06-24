import 'package:edu_sync/models/institution_model.dart';
import 'package:edu_sync/models/teacher_model.dart';
import 'package:edu_sync/models/group_model.dart';
import 'package:edu_sync/models/subject_model.dart';
import 'package:edu_sync/models/lesson_model.dart';

class TeacherCache {
  static TeacherModel? currentTeacher;
  static InstitutionModel? currenInstitution;

  static List<GroupModel>? cachedGroups;
  static List<SubjectModel>? cachedSubjects;
  static List<LessonModel>? cachedLessons;
}
