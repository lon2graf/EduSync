import 'package:edu_sync/models/lesson_model.dart';
import 'package:edu_sync/screens/student/dashboard_screen.dart';
import 'package:edu_sync/screens/student/lesson_comments.dart';
import 'package:edu_sync/screens/student/profile_screen.dart';
import 'package:edu_sync/screens/teacher/profile_screen.dart';
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
import 'package:edu_sync/screens/education_head/group_screen.dart';
import 'package:edu_sync/screens/education_head/students.dart';
import 'package:edu_sync/screens/education_head/subject_screen.dart';
import 'package:edu_sync/screens/teacher/login_screen.dart';
import 'package:edu_sync/screens/teacher/dashboard_screen.dart';
import 'package:edu_sync/screens/teacher/lessons_screen.dart';
import 'package:edu_sync/screens/teacher/lesson_comments_screen.dart';
import 'package:edu_sync/screens/teacher/grade_screen.dart';
import 'package:edu_sync/screens/teacher/attendance_screen.dart';
import 'package:edu_sync/screens/student/login_screen.dart';

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
      GoRoute(
        path: '/education_head/groups',
        builder: (context, state) => const EducationHeadGroupsScreen(),
      ),
      GoRoute(
        path: '/education_head/students',
        builder: (context, state) => const EducationHeadStudentsScreen(),
      ),
      GoRoute(
        path: '/education_head/subjects',
        builder: (context, state) => const EducationHeadSubjectsScreen(),
      ),
      GoRoute(
        path: '/teacher/login',
        builder: (context, state) => const TeacherLoginScreen(),
      ),
      GoRoute(
        path: '/teacher/dashboard',
        builder: (context, state) {
          final email = state.extra as String;
          return TeacherDashboard();
        },
      ),
      GoRoute(
        path: '/teacher/profile',
        builder: (context, state) => const TeacherProfileScreen(),
      ),
      GoRoute(
        path: '/teacher/lessons',
        builder: (context, state) => const TeacherAddLessonScreen(),
      ),
      GoRoute(
        path: '/teacher/lesson_comments',
        builder: (context, state) {
          final lesson_id = state.extra as int;
          return LessonCommentsScreen();
        },
      ),
      GoRoute(
        path: '/teacher/grades',
        builder: (context, state) {
          final lesson = state.extra as LessonModel;
          return TeacherGradeScreen();
        },
      ),
      GoRoute(
        path: '/teacher/attendance',
        builder: (context, state) {
          final lesson = state.extra as LessonModel;
          return LessonAttendanceScreen();
        },
      ),
      GoRoute(
        path: '/student/login',
        builder: (context, state) => const StudentLoginScreen(),
      ),
      GoRoute(
        path: '/student/dashboard',
        builder: (context, state) {
          final email = state.extra as String;
          return StudentDashboardScreen();
        },
      ),
      GoRoute(
        path: '/student/profile',
        builder: (context, state) => const StudentProfileScreen(),
      ),
      GoRoute(
        path: '/student/comment_lesson',
        builder: (context, state) => const StudentLessonCommentsScreen(),
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
      debugShowCheckedModeBanner: false,
      title: 'EduSync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
