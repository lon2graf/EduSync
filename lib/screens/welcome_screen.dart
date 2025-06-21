import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Логотип
              Center(
                child: SvgPicture.asset('assets/EduSync.svg', height: 200),
              ),
              const SizedBox(height: 24),

              // Название программы
              const Text(
                'EduSync — система оценки и обратной связи',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),

              // Кнопка "Подключить к ОО"
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/request');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.school),
                label: const Text(
                  'Подключить к ОО',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 12),

              // Ссылка "или проверить статус заявки"
              TextButton.icon(
                onPressed: () {
                  context.go('/check_request');
                },
                icon: const Icon(
                  Icons.mark_email_read,
                  color: Colors.blueAccent,
                ),
                label: const Text(
                  'Проверить статус заявки',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
                style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              ),

              const Divider(height: 40, thickness: 1),
              TextButton.icon(
                onPressed: () {
                  context.go('/education_head/login_education_head');
                },
                icon: const Icon(Icons.person, color: Colors.black87),
                label: const Text(
                  'Войти как руководитель ОО',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                style: TextButton.styleFrom(foregroundColor: Colors.black87),
              ),

              const SizedBox(height: 8),
              // Вход как ученик
              TextButton.icon(
                onPressed: () {
                  context.go('/student-login');
                },
                icon: const Icon(Icons.person, color: Colors.black87),
                label: const Text(
                  'Войти как ученик',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                style: TextButton.styleFrom(foregroundColor: Colors.black87),
              ),
              const SizedBox(height: 8),

              // Вход как учитель
              TextButton.icon(
                onPressed: () {
                  context.go('/teacher-login');
                },
                icon: const Icon(Icons.person_outline, color: Colors.black87),
                label: const Text(
                  'Войти как учитель',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                style: TextButton.styleFrom(foregroundColor: Colors.black87),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
