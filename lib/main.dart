import 'package:edu_sync/supabase/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edu_sync/screens/welcome_screen.dart';
import 'package:edu_sync/screens/using_request_screen.dart';
import 'package:edu_sync/screens/splash_screen.dart';
import 'package:edu_sync/screens/request_status_check_screen.dart';
import 'package:edu_sync/screens/education_head/education_head_register_screen.dart';
import 'package:edu_sync/models/using_request_model.dart';
import 'package:edu_sync/screens/education_head/education_head_login_screen.dart';
import 'package:edu_sync/screens/education_head/dashboard_screen.dart';
import 'package:edu_sync/screens/education_head/profile.dart';
import 'package:edu_sync/screens/education_head/teachers_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    await SupabaseConfig.init();
  } catch (e, stackTrace) {
    print('Ошибка при инициализации: $e');
    print(stackTrace);
  }

  final GoRouter appRouter = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/request',
        builder: (context, state) => const UsingRequestScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/check_request',
        builder: (context, state) => const RequestStatusCheckScreen(),
      ),
      GoRoute(
        path: '/education_head/login_education_head',
        builder: (context, state) => const EducationHeadLoginScreen(),
      ),
      GoRoute(
        path: '/education_head/register_education_head',
        builder: (context, state) {
          final request = state.extra as UsingRequestModel;
          return EducationHeadRegisterScreen();
        },
      ),
      GoRoute(
        path: '/education_head/dashboard',
        builder: (context, state) {
          final email = state.extra as String;
          return EducationHeadDashboard();
        },
      ),
      GoRoute(
        path: '/education_head/profile',
        builder: (context, state) => const EducationHeadProfileScreen(),
      ),
      GoRoute(
        path: '/education_head/teachers',
        builder: (context, state) => const EducationHeadTeachersScreen(),
      ),
    ],
  );

  runApp(EduSyncApp(router: appRouter));
}

class EduSyncApp extends StatelessWidget {
  final GoRouter router;

  const EduSyncApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EduSync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
