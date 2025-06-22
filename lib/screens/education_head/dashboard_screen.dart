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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Личный кабинет'), centerTitle: true),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(
            icon: Icons.person,
            label: 'Профиль',
            onTap: () => context.push('/education_head/profile'),
          ),
          _DashboardCard(
            icon: Icons.group,
            label: 'Учителя',
            onTap: () => context.push('/education_head/teachers'),
          ),
          _DashboardCard(
            icon: Icons.book,
            label: 'Предметы',
            onTap: () => context.push('/education_head/subjects'),
          ),
          _DashboardCard(
            icon: Icons.calendar_month,
            label: 'Занятия',
            onTap: () => context.push('/education_head/lessons'),
          ),
          _DashboardCard(
            icon: Icons.bar_chart,
            label: 'Успеваемость',
            onTap: () => context.push('/education_head/performance'),
          ),
          _DashboardCard(
            icon: Icons.logout,
            label: 'Выйти',
            onTap: () {
              EducationHeadCache.cachedHead = null;
              EducationHeadCache.cachedInstitution = null;
              context.go('/education_head/login');
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
