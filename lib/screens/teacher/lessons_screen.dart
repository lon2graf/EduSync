import 'package:flutter/material.dart';
import 'package:edu_sync/models/lesson_model.dart';
import 'package:edu_sync/models/subject_model.dart';
import 'package:edu_sync/models/group_model.dart';
import 'package:edu_sync/services/lesson_services.dart';
import 'package:edu_sync/services/teacher_cache.dart';
import 'package:edu_sync/services/group_services.dart';
import 'package:edu_sync/services/subject_services.dart';
import 'package:go_router/go_router.dart';

class TeacherAddLessonScreen extends StatefulWidget {
  const TeacherAddLessonScreen({super.key});

  @override
  State<TeacherAddLessonScreen> createState() => _TeacherAddLessonScreenState();
}

class _TeacherAddLessonScreenState extends State<TeacherAddLessonScreen> {
  List<LessonModel> _lessons = [];
  List<SubjectModel> _subjects = [];
  List<GroupModel> _groups = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLessonsAndCache();
  }

  Future<void> _loadLessonsAndCache() async {
    setState(() => _isLoading = true);

    final teacherId = TeacherCache.currentTeacher?.id;
    final institutionId = TeacherCache.currenInstitution?.id;
    if (teacherId == null || institutionId == null) return;

    // Берём данные из кэша
    List<LessonModel>? cachedLessons = TeacherCache.cachedLessons;
    List<SubjectModel>? cachedSubjects = TeacherCache.cachedSubjects;
    List<GroupModel>? cachedGroups = TeacherCache.cachedGroups;

    // Если нет уроков в кэше — загружаем с БД и сохраняем
    if (cachedLessons == null) {
      cachedLessons = await LessonServices.getLessonsByTeacherId(teacherId);
      TeacherCache.cachedLessons = cachedLessons;
    }

    // Если нет предметов — загружаем и сохраняем
    if (cachedSubjects == null) {
      cachedSubjects = await SubjectServices.getSubjectsByInstitutionId(
        institutionId,
      );
      TeacherCache.cachedSubjects = cachedSubjects;
    }

    // Если нет групп — загружаем и сохраняем
    if (cachedGroups == null) {
      cachedGroups = await GroupServices.getGroupsByInstitutionId(
        institutionId,
      );
      TeacherCache.cachedGroups = cachedGroups;
    }

    setState(() {
      _lessons = cachedLessons!;
      _subjects = cachedSubjects!;
      _groups = cachedGroups!;
      _isLoading = false;
    });
  }

  Widget _buildLessonTile(LessonModel lesson) {
    final subject = _subjects.firstWhere(
      (s) => s.id == lesson.subjectId,
      orElse: () => SubjectModel(id: -1, name: 'Неизвестно', instituteId: 0),
    );
    final group = _groups.firstWhere(
      (g) => g.id == lesson.groupId,
      orElse: () => GroupModel(id: -1, name: 'Неизвестно', instituteId: 0),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.book),
              title: Text(subject.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lesson.topic != null) Text('Тема: ${lesson.topic}'),
                  Text('Группа: ${group.name}'),
                  Text(
                    'Дата: ${lesson.date.toLocal().toString().substring(0, 16)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  context.push('/teacher/lesson_comments', extra: lesson.id);
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Обсудить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои занятия'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddLessonDialog,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _lessons.isEmpty
              ? const Center(child: Text('У вас пока нет занятий'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _lessons.length,
                itemBuilder:
                    (context, index) => _buildLessonTile(_lessons[index]),
              ),
    );
  }

  Future<void> _showAddLessonDialog() async {
    final formKey = GlobalKey<FormState>();
    final topicController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    SubjectModel? selectedSubject;
    GroupModel? selectedGroup;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить занятие'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<SubjectModel>(
                        decoration: const InputDecoration(labelText: 'Предмет'),
                        items:
                            _subjects.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(s.name),
                              );
                            }).toList(),
                        onChanged:
                            (val) => setState(() => selectedSubject = val),
                        validator:
                            (val) => val == null ? 'Выберите предмет' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<GroupModel>(
                        decoration: const InputDecoration(labelText: 'Группа'),
                        items:
                            _groups.map((g) {
                              return DropdownMenuItem(
                                value: g,
                                child: Text(g.name),
                              );
                            }).toList(),
                        onChanged: (val) => setState(() => selectedGroup = val),
                        validator:
                            (val) => val == null ? 'Выберите группу' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: topicController,
                        decoration: const InputDecoration(
                          labelText: 'Тема занятия',
                        ),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? 'Введите тему'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Дата: ${selectedDate.toLocal().toString().substring(0, 16)}',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                    selectedDate,
                                  ),
                                );
                                if (time != null) {
                                  setState(() {
                                    selectedDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                }
                              }
                            },
                            child: const Text('Выбрать'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          final newLesson = LessonModel(
                            id: null,
                            subjectId: selectedSubject!.id!,
                            teacherId: TeacherCache.currentTeacher!.id!,
                            date: selectedDate,
                            topic: topicController.text.trim(),
                            groupId: selectedGroup!.id!,
                          );

                          final success = await LessonServices.addLesson(
                            newLesson,
                          );

                          if (success) {
                            TeacherCache.cachedLessons = null;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Занятие добавлено ✅'),
                              ),
                            );
                            _loadLessonsAndCache();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ошибка при добавлении ❌'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Сохранить'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }
}
