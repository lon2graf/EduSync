import 'package:flutter/material.dart';
import 'package:edu_sync/models/group_model.dart';
import 'package:edu_sync/services/group_services.dart';
import 'package:edu_sync/services/education_head_cache.dart';

class EducationHeadGroupsScreen extends StatefulWidget {
  const EducationHeadGroupsScreen({Key? key}) : super(key: key);

  @override
  State<EducationHeadGroupsScreen> createState() =>
      _EducationHeadGroupsScreenState();
}

class _EducationHeadGroupsScreenState extends State<EducationHeadGroupsScreen> {
  List<GroupModel> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups({bool forceReload = false}) async {
    if (!forceReload && EducationHeadCache.cachedGroups != null) {
      setState(() {
        _groups = EducationHeadCache.cachedGroups!;
        _isLoading = false;
      });
      return;
    }

    final institutionId = EducationHeadCache.cachedInstitution?.id;
    if (institutionId == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    final groups = await GroupServices.getGroupsByInstitutionId(institutionId);
    EducationHeadCache.cachedGroups = groups;

    setState(() {
      _groups = groups;
      _isLoading = false;
    });
  }

  Future<void> _showAddGroupDialog() async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final institutionId = EducationHeadCache.cachedInstitution?.id;
    if (institutionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: не найден институт')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Добавить группу'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Название группы'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
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

                  final newGroup = GroupModel(
                    id: null,
                    name: nameController.text.trim(),
                    instituteId: institutionId,
                  );

                  final success = await GroupServices.addGroup(newGroup);

                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Группа добавлена ✅')),
                    );
                    EducationHeadCache.cachedGroups = null;
                    _loadGroups(forceReload: true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Группы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadGroups(forceReload: true),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddGroupDialog,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _groups.isEmpty
              ? const Center(child: Text('Группы не найдены'))
              : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.group),
                        title: Text(
                          group.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
