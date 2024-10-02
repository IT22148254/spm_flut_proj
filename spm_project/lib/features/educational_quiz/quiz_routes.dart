import 'package:spm_project/features/educational_quiz/user_dashboard.dart';
import 'package:spm_project/features/educational_quiz/admin_dashboard.dart';
import 'package:go_router/go_router.dart';

final quizRoutes = [
  GoRoute(
    path: '/quiz_admin',
    name: 'quiz_admin',
    builder: (context, state) => const AdminDashboard(),
  ),
  GoRoute(
    path: '/quiz',
    name: 'quiz',
    builder: (context, state) => const UserDashboard(),
  ),
];