import 'package:flutter/material.dart';
import 'package:edu_sync/models/student_model.dart';
import 'package:edu_sync/services/student_cache.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  StudentModel? _student;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final cachedStudent = StudentCache.currentStudent;

    if (cachedStudent != null) {
      setState(() {
        _student = cachedStudent;
        _isLoading = false;
      });
    } else {
      print('❗ Не удалось прогрузить кэш студента');
    }
  }

  Widget _buildInfoTile(String label, String? value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon ?? Icons.info_outline, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? '—',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> content) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...content,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль студента'), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _student == null
              ? const Center(child: Text('Не удалось загрузить профиль'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'EduSync',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent.shade700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionCard('Личные данные', [
                      _buildInfoTile(
                        'Фамилия',
                        _student!.surname,
                        icon: Icons.person,
                      ),
                      _buildInfoTile('Имя', _student!.name, icon: Icons.badge),
                      _buildInfoTile(
                        'Отчество',
                        _student!.patronymic,
                        icon: Icons.badge_outlined,
                      ),
                      _buildInfoTile(
                        'Email',
                        _student!.email,
                        icon: Icons.email,
                      ),
                    ]),
                  ],
                ),
              ),
    );
  }
}
