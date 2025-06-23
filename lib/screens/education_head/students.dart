import 'package:flutter/material.dart';
import 'package:edu_sync/models/group_model.dart';
import 'package:edu_sync/models/student_model.dart';
import 'package:edu_sync/services/education_head_cache.dart';
import 'package:edu_sync/services/group_services.dart';
import 'package:edu_sync/services/student_services.dart';

class EducationHeadStudentsScreen extends StatefulWidget {
  const EducationHeadStudentsScreen({super.key});

  @override
  State<EducationHeadStudentsScreen> createState() =>
      _EducationHeadStudentsScreenState();
}

class _EducationHeadStudentsScreenState
    extends State<EducationHeadStudentsScreen> {
  List<GroupModel> _groups = [];
  Map<int, List<StudentModel>> _studentsByGroup = {};
  Set<int> _expandedGroupIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroupsAndStudents();
  }

  Future<void> _loadGroupsAndStudents() async {
    final institutionId = EducationHeadCache.cachedInstitution?.id;
    if (institutionId == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    // 1. Получить группы из кэша или БД
    List<GroupModel> groups;
    if (EducationHeadCache.cachedGroups != null) {
      groups = EducationHeadCache.cachedGroups!;
    } else {
      groups = await GroupServices.getGroupsByInstitutionId(institutionId);
      EducationHeadCache.cachedGroups = groups;
    }

    setState(() {
      _groups = groups;
      _isLoading = false;
    });
  }

  Future<void> _loadStudentsForGroup(int groupId) async {
    if (EducationHeadCache.cachedStudentsByGroup.containsKey(groupId)) {
      setState(() {
        _studentsByGroup[groupId] =
            EducationHeadCache.cachedStudentsByGroup[groupId]!;
      });
      return;
    }

    final students = await StudentServices.getStudentsByGroupId(groupId);
    EducationHeadCache.cachedStudentsByGroup[groupId] = students;

    setState(() {
      _studentsByGroup[groupId] = students;
    });
  }

  Widget _buildStudentTile(StudentModel student) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text('${student.surname} ${student.name}'),
      subtitle: Text('Email: ${student.email}'),
    );
  }

  Widget _buildGroupTile(GroupModel group) {
    final isExpanded = _expandedGroupIds.contains(group.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        leading: const Icon(Icons.group),
        title: Text(group.name),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              _expandedGroupIds.add(group.id!);
              _loadStudentsForGroup(group.id!);
            } else {
              _expandedGroupIds.remove(group.id!);
            }
          });
        },
        children:
            (_studentsByGroup[group.id] ?? []).map(_buildStudentTile).toList(),
      ),
    );
  }

  Future<void> _showAddStudentDialog() async {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final patronymicController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    int? selectedGroupId;
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Добавить студента'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Группа',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          _groups.map((group) {
                            return DropdownMenuItem<int>(
                              value: group.id,
                              child: Text(group.name),
                            );
                          }).toList(),
                      onChanged: (value) => selectedGroupId = value,
                      validator:
                          (value) => value == null ? 'Выберите группу' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(surnameController, 'Фамилия', true),
                    _buildTextField(nameController, 'Имя', true),
                    _buildTextField(patronymicController, 'Отчество'),
                    _buildTextField(emailController, 'Email', true),
                    _buildTextField(passwordController, 'Пароль', true, true),
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

                  final newStudent = StudentModel(
                    id: null,
                    name: nameController.text.trim(),
                    surname: surnameController.text.trim(),
                    patronymic:
                        patronymicController.text.trim().isEmpty
                            ? null
                            : patronymicController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    groupId: selectedGroupId!,
                  );

                  final success = await StudentServices.addStudent(newStudent);
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Студент добавлен ✅')),
                    );
                    EducationHeadCache.cachedStudentsByGroup.remove(
                      selectedGroupId,
                    );
                    _loadStudentsForGroup(selectedGroupId!);
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
        title: const Text('Студенты по группам'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              EducationHeadCache.cachedStudentsByGroup.clear();
              _studentsByGroup.clear();
              _loadGroupsAndStudents();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddStudentDialog,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _groups.isEmpty
              ? const Center(child: Text('Группы не найдены'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  return _buildGroupTile(group);
                },
              ),
    );
  }
}
