import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_sync/services/education_head_servives.dart';
import 'package:edu_sync/services/institution_services.dart';
import 'package:edu_sync/services/education_head_cache.dart';

class EducationHeadDashboard extends StatefulWidget {
  const EducationHeadDashboard({Key? key}) : super(key: key);

  @override
  State<EducationHeadDashboard> createState() => _EducationHeadDashboardState();
}

class _EducationHeadDashboardState extends State<EducationHeadDashboard> {
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
    final head = await EducationHeadServives.getByEmail(email);
    if (!mounted) return;

    if (head == null) {
      print('❗ Не удалось загрузить руководителя');
      return;
    }

    final institution = await InstitutionService.getInstitutionById(
      head.institutionId,
    );
    if (!mounted) return;

    EducationHeadCache.cachedHead = head;
    EducationHeadCache.cachedInstitution = institution;

    setState(() => _isLoading = false);
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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель руководителя'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              EducationHeadCache.cachedHead = null;
              EducationHeadCache.cachedInstitution = null;
              EducationHeadCache.cachedGroups = null;
              EducationHeadCache.cachedStudentsByGroup.clear();
              context.go('/education_head/login_education_head');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildDashboardTile(
              context,
              icon: Icons.person,
              title: 'Профиль',
              subtitle: 'Просмотреть и отредактировать профиль',
              route: '/education_head/profile',
            ),
            const SizedBox(height: 16),
            _buildDashboardTile(
              context,
              icon: Icons.group,
              title: 'Учителя',
              subtitle: 'Список всех преподавателей учреждения',
              route: '/education_head/teachers',
            ),
            const SizedBox(height: 16),
            _buildDashboardTile(
              context,
              icon: Icons.groups,
              title: 'Группы',
              subtitle: 'Список учебных групп',
              route: '/education_head/groups',
            ),
            const SizedBox(height: 16),
            _buildDashboardTile(
              context,
              icon: Icons.school,
              title: 'Студенты',
              subtitle: 'Студенты по группам',
              route: '/education_head/students',
            ),
            const SizedBox(height: 16),
            _buildDashboardTile(
              context,
              icon: Icons.book,
              title: 'Предметы',
              subtitle: 'Предметы, читаемые в учреждении',
              route: '/education_head/subjects',
            ),
            const SizedBox(height: 16),
            _buildDashboardTile(
              context,
              icon: Icons.calendar_month,
              title: 'Занятия',
              subtitle: 'Планирование и список занятий',
              route: '/education_head/lessons',
            ),
            const SizedBox(height: 16),
            _buildDashboardTile(
              context,
              icon: Icons.bar_chart,
              title: 'Успеваемость',
              subtitle: 'Анализ и статистика оценок',
              route: '/education_head/performance',
            ),
          ],
        ),
      ),
    );
  }
}
