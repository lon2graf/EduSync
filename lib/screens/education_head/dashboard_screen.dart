import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EducationHeadDashboard extends StatelessWidget {
  const EducationHeadDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = GoRouterState.of(context).extra as String?;
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
            onTap: () => context.push('/education_head/profile', extra: email),
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
              // Очистка localStorage и переход на логин
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
