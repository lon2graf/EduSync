import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_sync/models/student_model.dart';
import 'package:edu_sync/models/grade_model.dart';
import 'package:edu_sync/models/lesson_model.dart';
import 'package:edu_sync/models/lesson_attendance_model.dart';
import 'package:edu_sync/services/student_services.dart';
import 'package:edu_sync/services/grade_services.dart';
import 'package:edu_sync/services/attendance_services.dart';
import 'package:edu_sync/services/lesson_services.dart';
import 'package:edu_sync/services/student_cache.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  bool _isLoading = true;
  late String email;
  late StudentModel student;
  List<GradeModel> _grades = [];
  List<LessonAttendance> _attendance = [];
  Map<int, LessonModel> _lessonMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      email = GoRouterState.of(context).extra as String;
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Получаем данные студента
    final fetchedStudent = await StudentServices.getStudentByEmail(email);
    if (fetchedStudent == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: студент не найден ❌')),
      );
      setState(() => _isLoading = false);
      return;
    }

    student = fetchedStudent;
    StudentCache.currentStudent = student;

    // Получаем оценки
    final fetchedGrades = await GradeServices.getGradesByStudentId(student.id!);
    if (fetchedGrades.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Оценки не найдены')));
    }
    _grades = fetchedGrades;

    // Получаем посещаемость
    final fetchedAttendance = await AttendanceService.getAttendanceByStudentId(
      student.id!,
    );
    _attendance = fetchedAttendance;

    // Получаем уроки по id
    final lessonIds = _grades.map((g) => g.lessonId).toSet();
    for (var lessonId in lessonIds) {
      final lesson = await LessonServices.getLessonById(lessonId);
      if (lesson != null) {
        _lessonMap[lessonId] = lesson;
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось загрузить урок с id $lessonId')),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Color _getGradeColor(int grade) {
    if (grade <= 2) return Colors.red.shade200;
    if (grade == 3) return Colors.orange.shade200;
    if (grade == 4) return Colors.lightBlue.shade200;
    return Colors.green.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Панель студента"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Профиль',
            onPressed: () {
              context.push('/student/profile', extra: student.email);
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Добро пожаловать, ${student.name}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Оценки",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ..._grades.map((grade) {
                      final lesson = _lessonMap[grade.lessonId];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _getGradeColor(grade.gradeValue),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          title: Text(
                            "Предмет: ${lesson?.topic ?? 'Без темы'}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Оценка: ${grade.gradeValue}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.comment),
                            tooltip: "Комментировать урок",
                            onPressed: () {
                              context.push(
                                '/student/comment_lesson',
                                extra: grade.lessonId,
                              );
                            },
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),
                    const Text(
                      "Пропуски",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ..._attendance
                        .where((a) => a.status == 'н' || a.status == 'нб')
                        .map((att) {
                          final lesson = _lessonMap[att.lessonId];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              title: Text(
                                "Предмет: ${lesson?.topic ?? 'Без темы'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Пропуск: ${att.status}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.comment),
                                tooltip: "Комментировать пропуск",
                                onPressed: () {
                                  context.push(
                                    '/student/comment_lesson',
                                    extra: att.lessonId,
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
    );
  }
}
