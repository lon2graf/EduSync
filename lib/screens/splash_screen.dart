import 'package:flutter/material.dart';
import 'package:edu_sync/services/local_storage_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isSent = await LocalStorageService.isApplicationSent();

    if (isSent) {
      context.push('/check_request');
    } else {
      context.push('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFF7F9FC), // очень светлый оттенок для лёгкого градиента
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/EduSync.svg', width: 120, height: 120),
            const SizedBox(height: 24),
            const Text(
              'EduSync',
              style: TextStyle(
                color: Colors.black,
                fontSize: 38,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                fontFamily: 'Roboto', // можно поменять на любой другой шрифт
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Система учета и оценки',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
