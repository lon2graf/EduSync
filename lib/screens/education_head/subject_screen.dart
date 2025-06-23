import 'package:flutter/material.dart';
import 'package:edu_sync/models/subject_model.dart';
import 'package:edu_sync/services/education_head_cache.dart';
import 'package:edu_sync/services/subject_services.dart';

class EducationHeadSubjectsScreen extends StatefulWidget {
  const EducationHeadSubjectsScreen({super.key});

  @override
  State<EducationHeadSubjectsScreen> createState() =>
      _EducationHeadSubjectsScreenState();
}

class _EducationHeadSubjectsScreenState
    extends State<EducationHeadSubjectsScreen> {
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects({bool forceReload = false}) async {
    final institutionId = EducationHeadCache.cachedInstitution?.id;
    if (institutionId == null) {
      setState(() => _isLoading = false);
      return;
    }

    if (!forceReload && EducationHeadCache.cachedSubjects != null) {
      setState(() {
        _subjects = EducationHeadCache.cachedSubjects!;
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    final subjects = await SubjectServices.getSubjectsByInstitutionId(
      institutionId,
    );
    EducationHeadCache.cachedSubjects = subjects;

    setState(() {
      _subjects = subjects;
      _isLoading = false;
    });
  }

  Future<void> _showAddSubjectDialog() async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final institutionId = EducationHeadCache.cachedInstitution?.id;
    if (institutionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: институт не найден')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Добавить предмет'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название предмета',
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Введите название'
                            : null,
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

                  final newSubject = SubjectModel(
                    id: null,
                    name: nameController.text.trim(),
                    instituteId: institutionId,
                  );

                  final success = await SubjectServices.addSubject(newSubject);

                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Предмет добавлен ✅')),
                    );
                    EducationHeadCache.cachedSubjects = null;
                    _loadSubjects(forceReload: true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ошибка при добавлении ❌')),
                    );
                  }
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Предметы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadSubjects(forceReload: true),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddSubjectDialog,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _subjects.isEmpty
              ? const Center(child: Text('Предметы не найдены'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(
                        subject.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
