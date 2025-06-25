import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_sync/models/teacher_model.dart';
import 'package:edu_sync/services/teacher_cache.dart';
import 'package:edu_sync/services/teacher_services.dart';
import 'package:edu_sync/services/institution_services.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  bool _isLoading = true;
  String? _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoading) {
      _email = GoRouterState.of(context).extra as String?;
      if (_email != null) _loadCache(_email!);
    }
  }

  Future<void> _loadCache(String email) async {
    final teacher = await TeacherServices.getTeacherByEmail(email);
    if (!mounted) return;

    if (teacher == null) {
      print('❗ Не удалось загрузить руководителя');
      return;
    }

    final institution = await InstitutionService.getInstitutionById(
      teacher.instituteId,
    );
    if (!mounted) return;

    TeacherCache.currentTeacher = teacher;
    TeacherCache.currenInstitution = institution;

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель преподавателя'),
        actions: [
          if (TeacherCache.currentTeacher != null)
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                context.push('/teacher/profile');
              },
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TeacherCache.currentTeacher == null
              ? const Center(child: Text('Не удалось загрузить данные'))
              : Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    _buildDashboardTile(
                      context,
                      icon: Icons.book_outlined,
                      title: 'Мои занятия',
                      subtitle: 'Создавайте и просматривайте уроки',
                      route: '/teacher/lessons',
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
