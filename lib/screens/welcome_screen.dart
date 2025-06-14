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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Логотип
              SvgPicture.asset(
                'assets/EduSync.svg', // путь к svg файлу
                height: 250,
              ),
              const SizedBox(height: 24),

              // Название программы
              const Text(
                'EduSync — система оценки и обратной связи',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),

              // Кнопка "Подключить к ОО"
              ElevatedButton(
                onPressed: () {
                  context.go('/request');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Подключить к ОО'),
              ),
              const SizedBox(height: 16),

              // Кнопка "Войти как ученик"
              OutlinedButton(
                onPressed: () {
                  // переход на логин для ученика
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Войти как ученик'),
              ),
              const SizedBox(height: 16),

              // Кнопка "Войти как учитель"
              OutlinedButton(
                onPressed: () {
                  // переход на логин для учителя
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Войти как учитель'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
