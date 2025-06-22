import 'package:flutter/material.dart';
import 'package:edu_sync/models/teacher_model.dart';
import 'package:edu_sync/services/teacher_services.dart';
import 'package:edu_sync/services/education_head_cache.dart';

class EducationHeadTeachersScreen extends StatefulWidget {
  const EducationHeadTeachersScreen({Key? key}) : super(key: key);

  @override
  State<EducationHeadTeachersScreen> createState() =>
      _EducationHeadTeachersScreenState();
}

class _EducationHeadTeachersScreenState
    extends State<EducationHeadTeachersScreen> {
  static List<TeacherModel>? _cachedTeachers;

  List<TeacherModel> _teachers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers({bool forceReload = false}) async {
    if (!forceReload && _cachedTeachers != null) {
      setState(() {
        _teachers = _cachedTeachers!;
        _isLoading = false;
      });
      return;
    }

    final institutionId = EducationHeadCache.cachedInstitution?.id;
    if (institutionId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final teachers = await TeacherServices.getTeachersByInstitutionId(
      institutionId,
    );

    _cachedTeachers = teachers;

    setState(() {
      _teachers = teachers;
      _isLoading = false;
    });
  }

  Future<void> _showAddTeacherDialog() async {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final patronymicController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final departmentController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final institutionId = EducationHeadCache.cachedInstitution?.id;

    if (institutionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: не найдено учебное заведение')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Добавить учителя'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: surnameController,
                      decoration: const InputDecoration(labelText: 'Фамилия'),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Введите фамилию'
                                  : null,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Имя'),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Введите имя'
                                  : null,
                    ),
                    TextFormField(
                      controller: patronymicController,
                      decoration: const InputDecoration(labelText: 'Отчество'),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Введите email'
                                  : null,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                      validator:
                          (value) =>
                              (value == null || value.length < 6)
                                  ? 'Минимум 6 символов'
                                  : null,
                    ),
                    TextFormField(
                      controller: departmentController,
                      decoration: const InputDecoration(labelText: 'Кафедра'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  final newTeacher = TeacherModel(
                    id: null,
                    name: nameController.text.trim(),
                    surname: surnameController.text.trim(),
                    patronymic:
                        patronymicController.text.trim().isEmpty
                            ? null
                            : patronymicController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    department:
                        departmentController.text.trim().isEmpty
                            ? null
                            : departmentController.text.trim(),
                    instituteId: institutionId,
                  );

                  final success = await TeacherServices.addTeacher(newTeacher);

                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Учитель добавлен ✅')),
                    );
                    _cachedTeachers = null; // сброс кэша
                    _loadTeachers(forceReload: true); // обновить список
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ошибка при добавлении')),
                    );
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, [
    bool required = false,
    bool isPassword = false,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        obscureText: isPassword,
        validator:
            required
                ? (value) =>
                    (value == null || value.isEmpty) ? 'Введите $label' : null
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Учителя'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadTeachers(forceReload: true),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddTeacherDialog,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _teachers.isEmpty
              ? const Center(child: Text('Учителя не найдены'))
              : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: _teachers.length,
                  itemBuilder: (context, index) {
                    final teacher = _teachers[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                          '${teacher.surname} ${teacher.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${teacher.email}'),
                            if (teacher.department != null)
                              Text('Кафедра: ${teacher.department}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
