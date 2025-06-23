import 'package:edu_sync/models/education_head_model.dart';
import 'package:edu_sync/models/institution_model.dart';
import 'package:edu_sync/models/teacher_model.dart';
import 'package:edu_sync/models/group_model.dart';
import 'package:edu_sync/models/student_model.dart';
import 'package:edu_sync/models/subject_model.dart';

class EducationHeadCache {
  static EducationHeadModel? cachedHead;
  static InstitutionModel? cachedInstitution;
  static List<TeacherModel>? cachedTeachers;
  static List<GroupModel>? cachedGroups;
  static Map<int, List<StudentModel>> cachedStudentsByGroup = {};
  static List<SubjectModel>? cachedSubjects;
}
