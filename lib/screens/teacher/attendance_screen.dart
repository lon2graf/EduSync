import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_sync/models/lesson_model.dart';
import 'package:edu_sync/models/student_model.dart';
import 'package:edu_sync/models/lesson_attendance_model.dart';
import 'package:edu_sync/services/student_services.dart';
import 'package:edu_sync/services/attendance_services.dart';

class LessonAttendanceScreen extends StatefulWidget {
  const LessonAttendanceScreen({super.key});

  @override
  State<LessonAttendanceScreen> createState() => _LessonAttendanceScreenState();
}

class _LessonAttendanceScreenState extends State<LessonAttendanceScreen> {
  late final LessonModel lesson;
  List<StudentModel> _students = [];
  Map<int, String?> _attendance = {}; // studentId -> статус
  bool _isLoading = true;

  final List<String> _statuses = ['был', 'н', 'нб'];

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
      _attendance = {for (var s in loaded) s.id!: null};
      _isLoading = false;
    });
  }

  Future<void> _submitAttendance() async {
    for (var entry in _attendance.entries) {
      final studentId = entry.key;
      final status = entry.value;
      if (status != null) {
        final record = LessonAttendance(
          lessonId: lesson.id!,
          studentId: studentId,
          status: status,
        );
        await AttendanceService.addOrUpdateAttendance(record);
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Посещаемость сохранена ✅')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Посещаемость урока')),
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
                          title: Text('${student.surname} ${student.name}'),
                          trailing: DropdownButton<String>(
                            value: _attendance[student.id],
                            items:
                                _statuses.map((status) {
                                  return DropdownMenuItem(
                                    value: status,
                                    child: Text(status.toUpperCase()),
                                  );
                                }).toList(),
                            hint: const Text('Статус'),
                            onChanged: (val) {
                              setState(() {
                                _attendance[student.id!] = val;
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
                      label: const Text('Сохранить посещаемость'),
                      onPressed: _submitAttendance,
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
