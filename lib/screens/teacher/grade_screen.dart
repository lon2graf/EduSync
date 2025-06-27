import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_sync/models/lesson_model.dart';
import 'package:edu_sync/models/student_model.dart';
import 'package:edu_sync/models/grade_model.dart';
import 'package:edu_sync/services/student_services.dart';
import 'package:edu_sync/services/grade_services.dart';

class TeacherGradeScreen extends StatefulWidget {
  const TeacherGradeScreen({super.key});

  @override
  State<TeacherGradeScreen> createState() => _TeacherGradeScreenState();
}

class _TeacherGradeScreenState extends State<TeacherGradeScreen> {
  late final LessonModel lesson;
  List<StudentModel> _students = [];
  Map<int, int?> _grades = {}; // studentId -> оценка
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      lesson = GoRouterState.of(context).extra as LessonModel;
      _loadStudents();
    });
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    final loaded = await StudentServices.getStudentsByGroupId(lesson.groupId);
    setState(() {
      _students = loaded;
      _grades = {for (var s in loaded) s.id!: null};
      _isLoading = false;
    });
  }

  Future<void> _submitGrades() async {
    for (var entry in _grades.entries) {
      final studentId = entry.key;
      final gradeValue = entry.value;
      if (gradeValue != null) {
        final grade = GradeModel(
          lessonId: lesson.id!,
          studentId: studentId,
          gradeValue: gradeValue,
        );
        await GradeServices.addOrUpdateGrade(grade);
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Оценки сохранены ✅')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оценка студентов')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        return ListTile(
                          title: Text(student.name + ' ' + student.surname),
                          trailing: DropdownButton<int>(
                            value: _grades[student.id],
                            items:
                                [2, 3, 4, 5].map((grade) {
                                  return DropdownMenuItem(
                                    value: grade,
                                    child: Text(grade.toString()),
                                  );
                                }).toList(),
                            hint: const Text('Оценка'),
                            onChanged: (val) {
                              setState(() {
                                _grades[student.id!] = val;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Сохранить оценки'),
                      onPressed: _submitGrades,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
